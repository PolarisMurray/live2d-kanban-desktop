# AI Learning Companion - macOS App

This is a macOS application built with SwiftUI.

## Building and Running

### Option 1: Using Xcode (Recommended)

1. Open Xcode
2. Create a new macOS App project:
   - File → New → Project
   - Select "macOS" → "App"
   - Product Name: `AILearningCompanion`
   - Interface: SwiftUI
   - Language: Swift

3. Add the Sources folder to your project:
   - Drag the `Sources` folder into your Xcode project
   - Make sure "Copy items if needed" is checked
   - Add to target: `AILearningCompanion`

4. Set the app entry point:
   - In your main App file, replace the default code with:
   ```swift
   import SwiftUI
   
   @main
   struct AILearningCompanionApp: App {
       var body: some Scene {
           WindowGroup {
               ContentView()
           }
       }
   }
   ```
   - Or simply use `LearningCompanionApp` from `Sources/UI/LearningCompanionApp.swift`

5. Configure the project:
   - Set Deployment Target to macOS 13.0 or later
   - Add entitlements file: `AILearningCompanion.entitlements`
   - Set Info.plist if needed

6. Build and Run (⌘R)

### Option 2: Using Swift Package Manager

1. Open Terminal in the project directory
2. Build the package:
   ```bash
   swift build
   ```
3. To create an app bundle, you'll need to use Xcode or create a script

### Option 3: Using Swift Package Manager with Xcode

1. In Xcode: File → New → Project
2. Select "macOS" → "App"
3. File → Add Packages...
4. Add Local Package and select this directory
5. The Sources will be available as a library

## Project Structure

```
Sources/
├── AIEngine/          # AI provider and chat functionality
├── Live2D/           # Live2D character rendering
├── OCR/              # Text recognition
├── StudyModules/     # Study tools (flashcards, pomodoro, etc.)
└── UI/               # SwiftUI views and app structure
```

## Requirements

- macOS 13.0 or later
- Xcode 14.0 or later
- Swift 5.9 or later

## Features

- Live2D character rendering with Metal
- AI-powered chat interface
- OCR text extraction
- Study tools (Flashcards, Pomodoro timer)
- PDF report generation
- Theme management

## Configuration

1. **API Key**: Set your OpenAI API key in Settings
2. **Live2D Models**: Place model files in `Resources/Models/`
3. **Theme**: Customize appearance in Settings

## Troubleshooting

- If Metal rendering fails, ensure your Mac supports Metal
- For network requests, ensure entitlements allow network access
- For file access, ensure entitlements allow user-selected files

