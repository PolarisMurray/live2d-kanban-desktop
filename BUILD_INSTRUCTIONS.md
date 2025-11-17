# Build Instructions for macOS

## Prerequisites

- macOS 13.0 or later
- Xcode 14.0 or later (with Command Line Tools)
- Swift 5.9 or later

## Quick Start

### Method 1: Using Xcode (Easiest)

1. **Open Xcode** and create a new macOS App project
2. **Add Sources**: Drag the `Sources` folder into your Xcode project
3. **Set Entry Point**: Use `LearningCompanionApp` from `Sources/UI/LearningCompanionApp.swift`
4. **Configure**: Set minimum deployment to macOS 13.0
5. **Build & Run**: Press ⌘R

See `XCODE_SETUP.md` for detailed Xcode setup instructions.

### Method 2: Using Swift Package Manager

```bash
# Build the package
swift build

# Run tests (if any)
swift test
```

Note: SPM builds a library, not an app. You'll still need Xcode to create an app bundle.

### Method 3: Command Line Build

```bash
# Make build script executable
chmod +x build_macos.sh

# Run build script
./build_macos.sh
```

## Project Files Created

- `Package.swift` - Swift Package Manager configuration
- `AILearningCompanion.entitlements` - App sandbox entitlements
- `Info.plist` - App metadata
- `build_macos.sh` - Build script
- `README_MACOS.md` - macOS-specific documentation
- `XCODE_SETUP.md` - Detailed Xcode setup guide

## Platform Compatibility

✅ **macOS**: Fully supported
✅ **iOS**: Code is compatible but needs iOS project setup

## Key Features for macOS

- Native macOS window management
- Settings window (⌘,)
- Menu bar commands
- Metal rendering for Live2D
- File system access for models
- Network access for AI API

## Troubleshooting

### Build Errors

1. **"Cannot find type 'X' in scope"**
   - Ensure all files in `Sources` are added to target
   - Check target membership in File Inspector

2. **Metal compilation errors**
   - Ensure Metal framework is available
   - Check that your Mac supports Metal

3. **Network errors**
   - Verify entitlements allow network access
   - Check API key configuration

### Runtime Issues

1. **App crashes on launch**
   - Check console for error messages
   - Verify all dependencies are linked

2. **Live2D not rendering**
   - Ensure Metal is supported
   - Check model files are in correct location

3. **Settings not saving**
   - Verify UserDefaults access
   - Check app sandbox permissions

## Next Steps

1. Configure your OpenAI API key in Settings
2. Add Live2D model files to `Resources/Models/`
3. Customize app appearance
4. Test all features

For detailed setup, see `XCODE_SETUP.md`.

