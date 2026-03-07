.PHONY: setup clean install build

setup:
	@echo "Setting up Flutter project..."
	@if [ -f "lib/main.dart" ]; then rm lib/main.dart && echo "Deleted lib/main.dart"; fi
	@if [ -f ".gitignore" ]; then rm .gitignore && echo "Deleted .gitignore"; fi
	@chmod +x set_up_folder/run_pub_add.sh
	@cd set_up_folder && sh run_pub_add.sh
	@cd set_up_folder && dart run create_folders.dart
	@echo "Setup complete!"

install:
	@echo "Installing packages..."
	@chmod +x set_up_folder/run_pub_add.sh
	@cd set_up_folder && sh run_pub_add.sh

generate:
	@echo "Generating files..."
	@cd set_up_folder && dart run create_folders.dart

build:
	@echo "Running build_runner..."
	@flutter pub run build_runner build --delete-conflicting-outputs

slang:
	@echo "Generating translations..."
	@dart run slang

clean:
	@echo "Cleaning project..."
	@flutter clean
	@flutter pub get

all: setup build slang
	@echo "Project is ready!"
