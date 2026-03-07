# Project Requirements

## Overview
This is a Flutter project setup automation tool that generates a standardized project structure with common folders, files, and boilerplate code.

## Project Structure

### Setup System
- **create_folders.dart** - Main script that orchestrates folder and file generation
- **run_pub_add.sh** - Shell script to install required Flutter packages
- **common_content/** - Directory containing content generator classes for different aspects of the app

### Generated Structure

#### Common Folders
```
lib/common/
├── application/          # App-wide settings, colors, text styles, links
├── constants/           # Global constants, snacks, spaces
├── data/remote/         # Remote data sources
├── extensions/          # Dart extensions
├── helpers/             # Helper utilities (e.g., text field validators)
├── localization/i18n/   # Internationalization files
├── mixins/              # Reusable mixins (error handler, event transformer)
├── presentation/        # UI components
│   ├── widgets/app/     # App-level widgets (MyApp)
│   ├── widgets/themes/  # Theme configurations (light, dark, base)
│   └── assets_parts/    # Asset references (icons)
├── routing/             # Navigation and routing
├── services/            # Services layer
│   ├── di_container/    # Dependency injection
│   ├── error_service/   # Error handling and reporting
│   ├── file_pick/       # File picker service
│   │   └── exceptions/  # File picker exceptions
│   └── local_storage/   # Secure storage service
└── typography/          # Typography definitions
```

#### Features Structure
```
lib/features/first/
├── bloc/                # BLoC state management
├── constants/           # Feature-specific constants
├── data/
│   ├── models/          # Data models
│   └── providers/       # Data providers
└── presentation/
    ├── screens/         # Screen widgets
    └── parts/           # Screen components
```

## Key Services

### File Pick Service
- **Location**: `lib/common/services/file_pick/`
- **Purpose**: Handle file selection with platform file picker
- **Features**:
  - Pick single file with optional extension filtering
  - Pick multiple files with optional extension filtering
  - Pick JSON files specifically
- **Implementation**: Singleton pattern with `NetFilePickServiceImpl`
- **Exception Handling**: Custom `FilePickException` extending `FilePickServiceExceptions`

### Secure Storage Service
- **Location**: `lib/common/services/local_storage/`
- **Purpose**: Secure key-value storage using Flutter Secure Storage
- **Features**:
  - Read/write/delete operations
  - Read all stored values
  - Delete all stored values
  - Check if key exists
- **Implementation**: Singleton pattern with `SecureStorage`
- **Platform Support**: 
  - iOS: Keychain with first_unlock accessibility
  - Android: Encrypted shared preferences
- **Predefined Keys**: lang, theme, brightness

### Error Service
- **Location**: `lib/common/services/error_service/`
- **Purpose**: Centralized error handling and reporting
- **Features**:
  - Talker integration for logging
  - Sentry integration for production error tracking
  - Flutter error handling
  - Platform dispatcher error handling

### DI Container
- **Location**: `lib/common/services/di_container/`
- **Purpose**: Dependency injection and service instantiation
- **Provides**: App initialization, routing, screen factory

## Content Generator Classes

### ServicesContent
Generates service layer files:
- `di(appName)` - Dependency injection container
- `errorService(appName)` - Error handling service
- `filePickService(appName)` - File picker service
- `filePickServiceExceptions` - File picker exceptions
- `secureStorage` - Secure storage service

### ApplicationContent
Generates application-level configurations:
- App settings
- Colors
- Text styles
- Links
- Button styles
- Decorations
- Paddings

### PresentationContent
Generates UI components:
- MyApp widget
- Theme configurations (light, dark, base)
- App icons

### RoutingContent
Generates navigation setup:
- Routes configuration with go_router

### LocalizationContent
Generates i18n files:
- String translations (slang format)

### Other Content Classes
- **CommonContent**: Main app file, .env, .gitignore, slang.yaml, launcher icons config
- **ConstantsContent**: Constants, global values, snacks, spaces
- **ExtensionsContent**: Dart extensions
- **HelpersContent**: Text field validators
- **MixinsContent**: Error handler mixin, event transformer mixin
- **ScreensContent**: Initial screens, home screen, BLoC files

## Setup Process

### Automated Setup (Recommended)
```bash
make setup
```

### Manual Setup Steps
1. Delete old files: `rm lib/main.dart .gitignore`
2. Install packages: `cd set_up_folder && sh run_pub_add.sh && cd ..`
3. Generate structure: `cd set_up_folder && dart run create_folders.dart && cd ..`

## Required Packages
- flutter_localizations (SDK)
- intl
- slang, slang_flutter (i18n)
- go_router (navigation)
- flutter_bloc, bloc (state management)
- dio, talker_dio_logger (networking)
- talker_flutter (logging)
- flutter_dotenv (environment variables)
- flutter_secure_storage (secure storage)
- freezed (code generation)
- dartz (functional programming)
- bloc_concurrency, rxdart (reactive programming)
- Dev dependencies: build_runner, flutter_launcher_icons, flutter_native_splash, flutter_lints, freezed_annotation

## Configuration Files Generated
- **.env** - Environment variables (URL placeholder)
- **slang.yaml** - Localization configuration
- **.gitignore** - Git ignore rules
- **flutter_launcher_icons.yaml** - App icon configuration

## Design Patterns
- **Singleton**: Used for services (FilePickService, SecureStorage, ErrorService)
- **Abstract Factory**: DI container for creating app components
- **Repository Pattern**: Data layer structure with models and providers
- **BLoC Pattern**: State management for features

## Error Handling Strategy
- Try-catch blocks in all service methods
- Custom exception types for different services
- Centralized error reporting through ErrorService
- Talker for development logging
- Sentry for production error tracking

## Recent Additions
1. File pick service with exception handling
2. Secure storage service with platform-specific configurations
3. Automated folder and file generation system
4. Content generator classes for consistent code structure
