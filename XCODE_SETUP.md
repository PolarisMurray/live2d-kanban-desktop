# Xcode Project Setup for macOS

## Quick Setup Guide

### Step 1: Create New Xcode Project

1. Open Xcode
2. **File → New → Project** (⌘⇧N)
3. Select **macOS** tab
4. Choose **App**
5. Click **Next**
6. Fill in:
   - **Product Name**: `AILearningCompanion`
   - **Team**: Your development team
   - **Organization Identifier**: `com.yourcompany` (or your domain)
   - **Interface**: **SwiftUI**
   - **Language**: **Swift**
   - **Storage**: **None** (or SwiftData if you want persistence)
7. Choose a location and click **Create**

### Step 2: Add Source Files

1. In Xcode, right-click on the project name in the navigator
2. Select **Add Files to "AILearningCompanion"...**
3. Navigate to and select the `Sources` folder
4. Make sure:
   - ✅ **Copy items if needed** is **UNCHECKED** (we want references)
   - ✅ **Create groups** is selected
   - ✅ **Add to targets: AILearningCompanion** is checked
5. Click **Add**

### Step 3: Configure App Entry Point

1. Open `AILearningCompanionApp.swift` (or `App.swift` - the default file)
2. Replace its contents with:

```swift
import SwiftUI

@main
struct AILearningCompanionApp: App {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(themeManager)
                .environmentObject(appState)
                .preferredColorScheme(themeManager.colorScheme)
        }
        #if os(macOS)
        .windowStyle(.automatic)
        .defaultSize(width: 1000, height: 700)
        #endif
        .commands {
            CommandGroup(replacing: .newItem) {}
            
            CommandMenu("Study") {
                Button("New Study Session") {
                    // TODO: Open new study session
                }
                .keyboardShortcut("n", modifiers: .command)
                
                Button("Generate Flashcards") {
                    // TODO: Open flashcard generator
                }
                .keyboardShortcut("f", modifiers: .command)
            }
        }
        
        #if os(macOS)
        Settings {
            SettingsView()
                .environmentObject(themeManager)
                .environmentObject(appState)
        }
        #endif
    }
}
```

Or simply import and use the existing `LearningCompanionApp`:

```swift
import SwiftUI

// The LearningCompanionApp is already defined in Sources/UI/LearningCompanionApp.swift
// Just make sure it's accessible
```

### Step 4: Configure Build Settings

1. Select the project in the navigator
2. Select the **AILearningCompanion** target
3. Go to **General** tab:
   - **Minimum Deployments**: macOS 13.0
   - **App Icons**: Add your app icon if you have one
4. Go to **Signing & Capabilities**:
   - Enable **App Sandbox**
   - Add capabilities:
     - ✅ **Outgoing Connections (Client)**
     - ✅ **User Selected File (Read/Write)**

### Step 5: Add Entitlements

1. **File → New → File**
2. Select **macOS → Resource → Property List**
3. Name it: `AILearningCompanion.entitlements`
4. Add the following keys (or use the provided entitlements file):
   - `com.apple.security.app-sandbox` = `YES`
   - `com.apple.security.files.user-selected.read-write` = `YES`
   - `com.apple.security.network.client` = `YES`

### Step 6: Build and Run

1. Select **My Mac** as the run destination
2. Press **⌘R** to build and run
3. The app should launch!

## Troubleshooting

### "Cannot find 'LearningCompanionApp' in scope"
- Make sure all files in `Sources` are added to the target
- Check that the files are in the correct target membership

### Metal rendering issues
- Ensure your Mac supports Metal (all modern Macs do)
- Check that Metal framework is linked

### Network requests fail
- Verify entitlements allow outgoing connections
- Check that API key is set in Settings

### File access issues
- Ensure entitlements allow user-selected file access
- For model loading, user must select files manually

## Project Structure in Xcode

After setup, your project should look like:

```
AILearningCompanion/
├── AILearningCompanionApp.swift (or App.swift)
├── Sources/
│   ├── AIEngine/
│   ├── Live2D/
│   ├── OCR/
│   ├── StudyModules/
│   └── UI/
├── Resources/
│   └── Models/
├── AILearningCompanion.entitlements
└── Info.plist
```

## Next Steps

1. Add your OpenAI API key in Settings
2. Add Live2D model files to Resources/Models/
3. Customize the app icon and branding
4. Test all features

Happy coding! 🚀

