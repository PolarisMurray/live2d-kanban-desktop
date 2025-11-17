#!/bin/bash

# Build script for macOS app
# This script helps set up and build the AI Learning Companion app for macOS

set -e

echo "Building AI Learning Companion for macOS..."

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "Error: Xcode is not installed. Please install Xcode from the App Store."
    exit 1
fi

# Check Swift version
SWIFT_VERSION=$(swift --version | head -n 1)
echo "Swift version: $SWIFT_VERSION"

# Build using Swift Package Manager
echo "Building with Swift Package Manager..."
swift build -c release

echo "Build complete!"
echo ""
echo "To create an Xcode project:"
echo "1. Open Xcode"
echo "2. File → New → Project"
echo "3. Select 'macOS' → 'App'"
echo "4. Add Sources folder to the project"
echo "5. Set the app entry point to LearningCompanionApp"
echo ""
echo "Or use: swift package generate-xcodeproj (if available)"

