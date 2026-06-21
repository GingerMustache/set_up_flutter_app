# Local CRUD Architecture

Portable reference for implementing SQLite-backed local persistence in a Flutter app. This document describes the pattern used by `LocalCardService` in Card Holder and how to replicate it in another project.

## Overview

Local data access is split into four layers. Each layer has a single responsibility; upper layers never talk to SQLite directly.

```
┌─────────────────────────────────────────────────────────────┐
│  Presentation (Bloc / UI)                                   │
│  Uses Either<Exception, T> from repository                  │
└───────────────────────────┬─────────────────────────────────┘
                            │
┌───────────────────────────▼─────────────────────────────────┐
│  Repository (domain)                                        │
│  CardRepository / CardRepositoryImpl                        │
│  ErrorHandlerMixin → wraps service calls in Either          │
└───────────────────────────┬─────────────────────────────────┘
                            │
┌───────────────────────────▼─────────────────────────────────┐
│  Service contract + implementation                          │
│  CardServiceAbstract ← LocalCardService (singleton)         │
│  sqflite CRUD, migrations, typed exceptions                 │
└───────────────────────────┬─────────────────────────────────┘
                            │
┌───────────────────────────▼─────────────────────────────────┐
│  SQLite file on disk                                        │
│  {appDocumentsDirectory}/card_hold.db                       │
└─────────────────────────────────────────────────────────────┘
```

**Why this shape**

| Layer | Role | Testability |
|-------|------|-------------|
| Service | Raw CRUD + DB lifecycle | Unit tests with `sqflite_common_ffi` |
| Repository | `Either` boundary + i18n error resolution | Mock the service contract |
| Bloc | UI state, no SQL knowledge | Mock the repository |
| DI | Wire concrete implementations once | Swap fakes in tests |

---

## File layout

```
lib/common/services/local_crud/
├── LOCAL_CRUD_ARCHITECTURE.md          # this file
├── local_card_service.dart             # abstract contract + singleton + SQL
├── model/
│   └── data_base_card.dart             # part file: row model + enum
└── local_data_base_error_message_resolver/
    └── local_data_base_error_message_resolver.dart

lib/common/exceptions/
└── crud_exceptions.dart                # LocalDataBaseException hierarchy

lib/domain/repositories/local/
└── card_repository.dart                # domain contract + impl

lib/common/mixins/
└── error_handler_mixin.dart            # safeCall → Either

lib/common/di_container/
└── di_container.dart                   # registers LocalCardService + repo
```

For a new entity (e.g. `Note`), mirror the same folders: one service file, one `part` model, one repository, exceptions prefixed with the entity name.

---

## Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  sqflite: ^2.4.2
  path_provider: ^2.1.5
  path: ^1.9.0
  equatable: ^2.0.5
  dartz: ^0.10.1

dev_dependencies:
  sqflite_common_ffi: ^2.3.0   # run SQLite on VM in unit tests
```

---

## Layer 1: Service (`LocalCardService`)

### Responsibilities

1. Open / close a single SQLite database (lazy open via `_ensureDbIsOpen()`).
2. Execute CRUD and domain-specific queries (`createCard`, `getCards`, `openCard`, …).
3. Map SQL rows ↔ Dart models (`DataBaseCard.fromRow`).
4. Throw typed `LocalDataBaseException` subclasses on failure.
5. Apply schema migrations in `onUpgrade`.

### Singleton pattern

One process-wide DB connection avoids duplicate opens and race conditions.

```dart
class LocalCardService implements CardServiceAbstract {
  Database? _db;

  static final LocalCardService _shared = LocalCardService._sharedInstance();
  LocalCardService._sharedInstance();
  factory LocalCardService() => _shared;
}
```

Register via DI as `CardServiceAbstract` so tests can inject a fake.

### Database lifecycle

| Method | Behavior |
|--------|----------|
| `open()` | Resolves path with `getApplicationDocumentsDirectory()`, calls `openDatabase()`. Throws `DatabaseIsAlreadyOpen` if `_db != null`. |
| `_ensureDbIsOpen()` | Calls `open()`, swallows `DatabaseIsAlreadyOpen`. Called at the start of every public CRUD method. |
| `close()` | Closes connection, sets `_db = null`. Throws `DatabaseIsNotOpen` if already closed. |

Path construction:

```dart
final docsPath = await getApplicationDocumentsDirectory();
final dbPath = join(docsPath.path, _dbName);  // e.g. "card_hold.db"
```

### Schema constants

Keep table/column names as top-level `const` strings in the service file. The `part` model imports them implicitly (same library).

```dart
const _dbName = "card_hold.db";
const _cardTable = "card";
const _idColumn = "id";
// ...

const _createCardTable = '''
  CREATE TABLE IF NOT EXISTS "card" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    ...
  );''';
```

### Current schema (`card` table)

| Column | SQL type | Notes |
|--------|----------|-------|
| `id` | INTEGER PK AUTOINCREMENT | Assigned on insert |
| `code` | TEXT | Stored without spaces (`replaceAll(' ', '')` on create) |
| `name` | TEXT | Display name |
| `color` | INTEGER NOT NULL | ARGB or palette index |
| `card_code_type` | TEXT | Enum stored as `name` (`barcode`, `qr`) |
| `usage_point` | INTEGER | Incremented by `openCard`; list sorted DESC |
| `url_path` | TEXT | Logo / asset path |
| `logo_size` | REAL | Default `30` when null in row |

DB version is currently **4**. A auxiliary `db_meta` table is created during migration from versions `< 3`.

### Migrations

Bump `version` in `openDatabase()` whenever the schema changes. Use incremental `onUpgrade` blocks:

```dart
onUpgrade: (db, oldVersion, newVersion) async {
  if (oldVersion < 3) {
    await db.execute('ALTER TABLE "card" ADD COLUMN "logo_size" REAL');
  }
  if (oldVersion < 4) {
    await db.execute('ALTER TABLE "card" ADD COLUMN "card_code_type" TEXT');
    await db.execute(
      '''UPDATE "card" SET "card_code_type" = 'barcode'
         WHERE "card_code_type" IS NULL''',
    );
  }
},
```

Rules for other projects:

- Never edit `_createCardTable` for existing installs; only use `onUpgrade`.
- Always backfill new NOT NULL-like columns with sensible defaults.
- Document each version bump in this file or a `CHANGELOG`.

### CRUD operation patterns

**Create** — `db.insert` with `conflictAlgorithm: ConflictAlgorithm.replace`, return model with generated `id`:

```dart
final cardId = await db.insert(_cardTable, { ... });
return DataBaseCard(id: cardId, ...);
```

**Read one** — `query` with `where: 'id = ?'`, `limit: 1`. Empty result → `CouldNotFindCard`.

**Read all** — `query` with `orderBy`. Card list uses `'usage_point DESC'` (most opened first).

**Update** — `db.update` with row count check. `0` rows → operation-specific exception (`CouldNotUpdateCard`).

**Delete one** — `db.delete` with `where`. `0` rows → `CouldNotDeleteCard`.

**Delete all** — `db.delete(_cardTable)` without `where`; returns deletion count.

**Domain action (`openCard`)** — read current row, increment `usage_point`, update. Returns the pre-update card (Bloc applies `+1` in memory for immediate UI sort).

### Error handling in the service

- Wrap `sqflite` calls in `try/catch` → rethrow as typed exception with optional `e.toString()`.
- Validate operation outcome (e.g. `updateColumn == 0`) → throw without underlying message.
- Infrastructure errors: `MissingPlatformDirectoryException` → `UnableToGetDocumentsDirectory`.

Do **not** localize strings here. Messages are resolved one layer up.

---

## Layer 2: Row model (`DataBaseCard`)

Defined as a `part of '../local_card_service.dart'` so it shares column constants without duplication.

### Conventions

```dart
class DataBaseCard extends Equatable {
  // fields...

  DataBaseCard.fromRow(Map<String, Object?> map)
    : id = map[_idColumn] as int,
      logoSize = (map[_logoSize] as num?)?.toDouble() ?? 30,
      cardCodeType = CardCodeType.fromString(map[_cardCodeTypeColumn] as String);

  DataBaseCard copyWith({ ... });
}
```

- Use `Equatable` for Bloc/state comparison.
- Provide `fromRow` factory for SQL → Dart.
- Provide `copyWith` for UI updates without re-fetching.
- Enums: persist `enum.name`, restore with `fromString` helper.

---

## Layer 3: Exceptions (`crud_exceptions.dart`)

```dart
abstract class LocalDataBaseException implements Exception {
  final String message;
  const LocalDataBaseException(this.message, {this.originalError});
}
```

Entity-specific types (`CouldNotFindCard`, `CouldNotCreateCard`, …) extend this base. Empty `message` means “use default i18n string” in the resolver.

Shared infrastructure exceptions (reusable across entities):

- `DatabaseIsNotOpen`
- `DatabaseIsAlreadyOpen`
- `UnableToGetDocumentsDirectory`
- `SomethingWentWrongWithDataBase`

---

## Layer 4: Error message resolver

Maps exception **type** → localized string when `message.isEmpty`:

```dart
static String resolveMessage(LocalDataBaseException exception) {
  if (exception.message.isEmpty) {
    final messageGetter = _defaultMessages[exception.runtimeType];
    return messageGetter?.call() ?? t.errors.localData.unknownDatabaseError;
  }
  return exception.message;
}
```

`withResolvedMessage` clones the exception with the resolved text so Bloc can call `showSnackBar(e.message)`.

In a new project without slang/i18n, replace the map with plain English strings or pass messages directly in the service.

---

## Layer 5: Repository (`CardRepositoryImpl`)

Bridges service throws → functional `Either`:

```dart
class CardRepositoryImpl with ErrorHandlerMixin implements CardRepository {
  final CardServiceAbstract localCardService;

  @override
  Future<Either<Exception, List<DataBaseCard>>> getCards() =>
      safeCall(() => localCardService.getCards());
}
```

`ErrorHandlerMixin.safeCall`:

```dart
Future<Either<Exception, T>> safeCall<T>(Future<T> Function() action) async {
  try {
    return Right(await action());
  } on LocalDataBaseException catch (e) {
    return Left(LocalDataBaseErrorMessageResolver.withResolvedMessage(e));
  } catch (e) {
    return Left(e as Exception);
  }
}
```

Presentation code uses `result.fold((error) => ..., (data) => ...)`.

---

## Layer 6: Dependency injection

```dart
@override
CardServiceAbstract makeCardService() => LocalCardService();

@override
CardRepository makeCardRepository() => CardRepositoryImpl(
  localCardService: makeCardService(),
  netShareRepository: makeShareRepository(),
);
```

Bloc receives `CardRepository`, not `LocalCardService`, keeping SQL out of UI logic.

---

## Data flow example: fetch all cards

```
CardsFetchCardsEvent
  → CardsBloc._onFetchCards
  → CardRepository.getCards()
  → ErrorHandlerMixin.safeCall
  → LocalCardService.getCards()
  → _ensureDbIsOpen → db.query(orderBy: usage_point DESC)
  → List<DataBaseCard.fromRow>
  → Either.right(cards)
  → emit(state.copyWith(cards: cards))
```

On failure:

```
sqflite throws / empty update
  → CouldNotFetchCards
  → safeCall → Left(withResolvedMessage(...))
  → Bloc fold left branch → showSnackBar(e.message)
```

---

## Testing strategy

Tests live in `test/local_card_service_test.dart`.

### Setup (VM / CI)

```dart
setUpAll(() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  // Mock path_provider → temp directory
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/path_provider'),
    (call) async => Directory.systemTemp.path,
  );
});
```

### Per-test isolation

Because `LocalCardService` is a singleton:

1. Delete `{temp}/card_hold.db` before each test.
2. `await cardService.open()`.
3. `await cardService.deleteAllCards()`.
4. In `tearDown`: `deleteAllCards()` + `close()`.

Repository/Bloc tests should mock `CardServiceAbstract` or `CardRepository` instead of hitting SQLite.

---

## Implementing a new local entity (checklist)

Use this when porting the pattern to another project or adding a second table.

### 1. Service contract

```dart
abstract class NoteServiceAbstract {
  Future<NoteRow> createNote({ required String title, required String body });
  Future<NoteRow> getNote({ required int id });
  Future<List<NoteRow>> getNotes();
  Future<void> deleteNote({ required int id });
  Future<NoteRow> updateNote({ required int id, required String title, ... });
}
```

### 2. Implementation skeleton

```dart
class LocalNoteService implements NoteServiceAbstract {
  Database? _db;
  static final _shared = LocalNoteService._();
  LocalNoteService._();
  factory LocalNoteService() => _shared;

  static const _dbName = 'app.db';        // shared DB or separate file
  static const _table = 'note';
  static const _version = 1;

  Future<void> _ensureDbIsOpen() async {
    try { await open(); } on DatabaseIsAlreadyOpen {}
  }

  Future<void> open() async { /* same as LocalCardService */ }
  Future<void> close() async { /* same as LocalCardService */ }
  Database _getDatabaseOrThrow() { /* same as LocalCardService */ }

  // CRUD methods: ensureDb → try/catch → typed exceptions
}
```

### 3. Model (`part` file)

- Fields matching columns.
- `fromRow(Map<String, Object?>)`.
- `copyWith`, `Equatable`.

### 4. Exceptions

Add `CouldNotFindNote`, `CouldNotCreateNote`, … extending `LocalDataBaseException`.

### 5. Resolver entries

Register each new exception type in `_defaultMessages`.

### 6. Repository

```dart
abstract class NoteRepository { ... Either return types ... }

class NoteRepositoryImpl with ErrorHandlerMixin implements NoteRepository {
  final NoteServiceAbstract _service;
  // delegate via safeCall
}
```

### 7. DI + Bloc

Wire service → repository → bloc. Bloc never imports `sqflite`.

### 8. Tests

Copy the FFI + path_provider mock setup; assert CRUD, migrations, and exception paths.

---

## Design decisions & trade-offs

| Decision | Rationale | Alternative |
|----------|-----------|-------------|
| Singleton service | One DB connection, simple `_ensureDbIsOpen` | Injectable non-singleton + connection pool |
| Exceptions vs Result in service | Keeps service API familiar; Either only at repository | Return `Either` from service directly |
| `part` model in service file | Shared private column constants | Separate file + duplicated const map |
| Lazy open | No startup cost if feature unused | Eager open in `main()` |
| `openCard` returns stale usage | Bloc increments locally for instant sort | Return refreshed row from DB after update |
| `ConflictAlgorithm.replace` on insert | Idempotent re-insert by primary key | `abort` to detect duplicates |

---

## Known quirks (Card Holder)

1. **`updateCard` return value** — returns `currentCard` fetched *before* the update, not the updated row. Bloc merges event fields manually.
2. **`createCard` code normalization** — spaces stripped only on insert, not on update.
3. **`DataBaseCard.toString`** — still says `"Note"` (legacy naming).
4. **Shared DB version** — all tables in `card_hold.db` share one `version` integer; coordinate migrations across tables.

---

## Quick API reference (`LocalCardService`)

| Method | Returns | Throws (examples) |
|--------|---------|---------------------|
| `open()` | `Future<void>` | `DatabaseIsAlreadyOpen`, `UnableToGetDocumentsDirectory` |
| `close()` | `Future<void>` | `DatabaseIsNotOpen` |
| `createCard(...)` | `Future<DataBaseCard>` | `CouldNotCreateCard` |
| `getCard(id:)` | `Future<DataBaseCard>` | `CouldNotFindCard` |
| `getCards()` | `Future<List<DataBaseCard>>` | `CouldNotFetchCards` |
| `updateCard(...)` | `Future<DataBaseCard>` | `CouldNotUpdateCard`, `CouldNotFindCard` |
| `openCard(id:)` | `Future<DataBaseCard>` | `CouldNotOpenCard`, `CouldNotFindCard` |
| `deleteCard(id:)` | `Future<void>` | `CouldNotDeleteCard` |
| `deleteAllCards()` | `Future<int>` | (count of deleted rows) |

---

## Related files in Card Holder

| File | Purpose |
|------|---------|
| `lib/common/services/local_crud/local_card_service.dart` | Service + schema + migrations |
| `lib/common/services/local_crud/model/data_base_card.dart` | Row model |
| `lib/common/exceptions/crud_exceptions.dart` | Exception types |
| `lib/common/services/local_crud/local_data_base_error_message_resolver/` | i18n mapping |
| `lib/common/mixins/error_handler_mixin.dart` | `Either` wrapper |
| `lib/domain/repositories/local/card_repository.dart` | Domain repository |
| `lib/common/di_container/di_container.dart` | Wiring |
| `lib/features/home/bloc/cards_bloc.dart` | Consumer example |
| `test/local_card_service_test.dart` | Service unit tests |
