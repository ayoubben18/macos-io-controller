.PHONY: build install clean run help

APP_NAME = macOSIOController
BUNDLE_NAME = $(APP_NAME).app
BUILD_DIR = .build/release
INSTALL_DIR = /Applications

# Build in release mode
build:
	swift build -c release

# Create app bundle and install to /Applications
install: build
	@echo "Creating app bundle..."
	@rm -rf $(BUNDLE_NAME)
	@mkdir -p $(BUNDLE_NAME)/Contents/MacOS
	@mkdir -p $(BUNDLE_NAME)/Contents/Resources
	@cp $(BUILD_DIR)/$(APP_NAME) $(BUNDLE_NAME)/Contents/MacOS/
	@cp Resources/Info.plist $(BUNDLE_NAME)/Contents/
	@echo "Installing to $(INSTALL_DIR)..."
	@rm -rf "$(INSTALL_DIR)/$(BUNDLE_NAME)"
	@cp -r $(BUNDLE_NAME) $(INSTALL_DIR)/
	@echo "Done! $(APP_NAME) installed to $(INSTALL_DIR)"

# Build and run locally (without installing)
run: build
	$(BUILD_DIR)/$(APP_NAME)

# Clean build artifacts
clean:
	swift package clean
	rm -rf $(BUNDLE_NAME)
	rm -rf .build

# Show help
help:
	@echo "Available targets:"
	@echo "  make build   - Build in release mode"
	@echo "  make install - Build and install to /Applications"
	@echo "  make run     - Build and run locally"
	@echo "  make clean   - Remove build artifacts"
