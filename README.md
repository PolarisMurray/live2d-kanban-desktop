<p align="center">
<img src="./assets/app.png" width=120px height=120px>
</p>

<h1 align="center">AI Learning Companion</h1>
<h3 align="center">An Intelligent Study Assistant with Live2D Character for macOS</h3>

<p align="center">
<img src="https://img.shields.io/badge/macOS-13.0+-blue.svg?style=flat-square">
<img src="https://img.shields.io/badge/Swift-5.9+-orange.svg?style=flat-square">
<img src="https://img.shields.io/badge/SwiftUI-Native-green.svg?style=flat-square">
<img src="https://img.shields.io/badge/License-GPL%20v3.0-purple.svg?style=flat-square">
</p>

---

## 🎯 What is AI Learning Companion?

**AI Learning Companion** is a native macOS application that combines an interactive Live2D character with AI-powered study tools. Think of it as your personal study buddy that helps you learn more effectively through conversation, flashcards, timed study sessions, and intelligent content generation.

### Key Features

✨ **Interactive Live2D Character**
- Beautiful animated character that responds to your study activities
- Real-time expressions and animations based on your progress
- Draggable floating window for always-on companionship

🤖 **AI-Powered Learning**
- Chat with GPT-4 for explanations, questions, and study help
- Generate flashcards automatically from your study materials
- Create multiple-choice questions from any text content
- OCR text extraction from images for quick note-taking

📚 **Study Tools**
- **Pomodoro Timer**: Focus sessions with automatic break management
- **Flashcard Generator**: AI creates study cards from your content
- **Question Generator**: Generate practice questions automatically
- **PDF Reports**: Weekly study summaries with performance metrics

🎨 **Native macOS Experience**
- Built with SwiftUI for smooth, native performance
- Metal-powered Live2D rendering
- macOS Settings integration (⌘,)
- Menu bar commands and keyboard shortcuts
- Beautiful, responsive interface

---

## 🚀 Quick Start for macOS / 快速开始

**中文用户**: 
- 查看 [README_CN.md](./README_CN.md) 获取完整中文版 README
- 查看 [运行指南.md](./运行指南.md) 获取详细的中文运行说明

### Prerequisites / 前置要求

- **macOS 13.0 (Ventura)** or later / macOS 13.0 或更高版本
- **Xcode 14.0** or later (for building) / Xcode 14.0 或更高版本（用于构建）
- An **OpenAI API key** (for AI features) / OpenAI API 密钥（用于 AI 功能）

### Installation Options

#### Option 1: Xcode Project (Recommended - Easiest)

1. **Open Xcode** and create a new project:
   - File → New → Project (⌘⇧N)
   - Select **macOS** → **App**
   - Product Name: `AILearningCompanion`
   - Interface: **SwiftUI**
   - Language: **Swift**

2. **Add Source Files**:
   - Right-click your project → **Add Files to "AILearningCompanion"...**
   - Select the `Sources` folder
   - ✅ **Create groups**
   - ✅ **Add to targets: AILearningCompanion**
   - ❌ **Uncheck "Copy items if needed"** (use references)

3. **Set App Entry Point**:
   - The app entry point is already defined in `Sources/UI/LearningCompanionApp.swift`
   - Your main App file should simply import and use it, or replace with:
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

4. **Configure Build Settings**:
   - Set **Minimum Deployments** to **macOS 13.0**
   - Add `AILearningCompanion.entitlements` file (provided in repo)
   - Enable **App Sandbox** with network and file access

5. **Build & Run**: Press **⌘R**

📖 **Detailed Setup**: See [XCODE_SETUP.md](./XCODE_SETUP.md) for step-by-step instructions.

#### Option 2: Swift Package Manager

```bash
# Clone the repository
git clone https://github.com/yourusername/live2d-kanban-desktop.git
cd live2d-kanban-desktop

# Build the package
swift build

# Or use the build script
chmod +x build_macos.sh
./build_macos.sh
```

> **Note**: SPM builds a library. To create an app bundle, you'll still need Xcode.

#### Option 3: Command Line Build

```bash
# Make build script executable
chmod +x build_macos.sh

# Run build
./build_macos.sh
```

---

## 📖 How to Use

### First Launch

1. **Configure API Key**:
   - Open **Settings** (⌘,)
   - Enter your OpenAI API key in the "AI Configuration" section
   - Click "Test Connection" to verify

2. **Load Live2D Model** (Optional):
   - Place Live2D model files in `Resources/Models/`
   - Or specify a model path in Settings

3. **Start Learning**:
   - Click **"Ask AI"** to start a conversation
   - Use **"OCR"** to extract text from images
   - Generate flashcards from study materials
   - Start a Pomodoro session for focused study

### Main Features

#### 💬 Chat with AI
- Type questions in the chat interface
- Get explanations, study tips, and help
- Conversation history is maintained during your session

#### 📸 OCR Text Extraction
- Click **"OCR"** button
- Select or paste an image
- Extract text automatically using Vision framework
- Use extracted text to generate flashcards or questions

#### 🎴 Generate Flashcards
- Click **"Flashcards"** button
- Paste or type your study material
- AI automatically creates question-answer pairs
- Review and study your flashcards

#### ⏱️ Pomodoro Timer
- Click **"Pomodoro"** button
- Start a 25-minute focus session
- Automatic breaks and progress tracking
- Character reacts to your study state

#### 🎭 Live2D Character
- Interactive character responds to your activities
- Expressions change based on study progress
- Floating window mode for always-visible companion
- Drag to reposition anywhere on screen

---

## 🏗️ Project Architecture

This is a **native Swift/SwiftUI** application built with modern Apple frameworks:

### Technology Stack

- **SwiftUI**: Native UI framework
- **Metal**: High-performance Live2D rendering
- **Vision**: OCR text recognition
- **PDFKit**: Report generation
- **Combine**: Reactive programming
- **Async/Await**: Modern concurrency

### Module Structure

```
Sources/
├── AIEngine/          # AI provider, chat, and content generation
├── Live2D/            # Live2D rendering and character management
├── OCR/               # Text extraction from images
├── StudyModules/      # Flashcards, Pomodoro, questions, reports
└── UI/                # SwiftUI views and app structure
```

### Architecture Principles

- **MVVM**: Model-View-ViewModel pattern
- **Protocol-Oriented**: Dependency injection via protocols
- **Modular Design**: Isolated, testable modules
- **Platform-Agnostic**: Works on macOS and iOS (with platform-specific optimizations)

📚 **Detailed Architecture**: See [Docs/Architecture.md](./Docs/Architecture.md)

---

## ⚙️ Configuration

### Settings (⌘,)

- **AI Configuration**: Set your OpenAI API key
- **Live2D Character**: Configure model path and settings
- **Study Preferences**: Customize Pomodoro durations, auto-start options
- **Appearance**: Choose theme (Light/Dark/System) and accent colors
- **Floating Window**: Enable/disable floating character window

### File Locations

- **Live2D Models**: `Resources/Models/` (or custom path in Settings)
- **Settings**: Stored in UserDefaults
- **Reports**: Generated PDFs can be saved anywhere

---

## 🔧 Troubleshooting

### App Won't Build

- **"Cannot find type 'X' in scope"**: Ensure all files in `Sources` are added to target
- **Metal errors**: Verify your Mac supports Metal (all modern Macs do)
- **Import errors**: Check that frameworks are properly linked

### Runtime Issues

- **AI Chat not working**: Verify API key is set and network access is enabled
- **Live2D not showing**: Check model files are in correct location
- **OCR not working**: Ensure image format is supported (JPEG, PNG)
- **Settings not saving**: Check app sandbox permissions

### Performance

- **Slow rendering**: Ensure Metal is enabled and GPU is available
- **High memory usage**: Normal for Live2D rendering; close other apps if needed

---

## 📋 Requirements

### System Requirements

- **macOS 13.0 (Ventura)** or later
- **Metal-capable GPU** (all modern Macs)
- **Internet connection** (for AI features)

### Development Requirements

- **Xcode 14.0** or later
- **Swift 5.9** or later
- **Command Line Tools**

### API Requirements

- **OpenAI API Key** (for AI chat and content generation)
  - Get one at: https://platform.openai.com/api-keys
  - Free tier available for testing

---

## 🎨 Features in Detail

### Live2D Integration

- **Metal-based rendering** for smooth 60fps animation
- **State machine** manages character emotions and behaviors
- **Pomodoro integration** - character reacts to study sessions
- **Expression system** - character shows different emotions
- **Motion playback** - animations for different states

### AI Engine

- **OpenAI GPT-4** integration
- **Context-aware conversations** - remembers recent messages
- **Flashcard generation** from any text content
- **Question generation** with multiple-choice options
- **Explanation system** for complex topics

### Study Modules

- **Flashcards**: Spaced repetition algorithm, difficulty tracking
- **Pomodoro**: 25/5/15 minute cycles, automatic phase transitions
- **Questions**: Multiple-choice with explanations
- **Reports**: PDF generation with performance metrics

### OCR Module

- **Vision framework** integration
- **Multi-language support**
- **Automatic text cleaning**
- **Image format support**: JPEG, PNG, HEIC

---

## 🛠️ Development

### Building from Source

```bash
# Clone repository
git clone https://github.com/yourusername/live2d-kanban-desktop.git
cd live2d-kanban-desktop

# Open in Xcode
open -a Xcode .

# Or build with SPM
swift build
```

### Project Files

- `Package.swift`: Swift Package Manager configuration
- `AILearningCompanion.entitlements`: App sandbox entitlements
- `Info.plist`: App metadata
- `Sources/`: All application source code
- `Resources/Models/`: Live2D model files location

### Code Structure

All code follows Apple's Swift API Design Guidelines:
- Clear, descriptive naming
- Protocol-oriented design
- Modern Swift concurrency (async/await)
- Comprehensive error handling
- Platform-agnostic where possible

---

## 📝 License

This project is open source under the **GPL v3.0** license.

**Note**: Live2D Cubism SDK usage is subject to the Cubism EULA. Model files are subject to their respective copyrights.

---

## 🙏 Acknowledgments

### Technologies Used

- **Live2D Cubism SDK**: Character rendering
- **SwiftUI**: Native UI framework
- **Metal**: GPU-accelerated rendering
- **Vision**: OCR capabilities
- **OpenAI API**: AI functionality

### Special Thanks

This project represents a complete rewrite from Electron to native Swift/SwiftUI, bringing:
- Better performance
- Lower resource usage
- Native macOS integration
- Modern Apple design patterns

---

## 🐛 Known Issues & Roadmap

### Current Limitations

- Live2D Cubism SDK integration is partially implemented (TODOs marked in code)
- Some advanced features require additional API setup
- Model loading needs manual configuration

### Planned Features

- [ ] Complete Live2D Cubism SDK integration
- [ ] Cloud sync for flashcards
- [ ] Widget extensions
- [ ] Siri Shortcuts integration
- [ ] Advanced study analytics
- [ ] Multiple language support

---

## 💬 Support & Contributing

### Getting Help

- **Issues**: Report bugs or request features on GitHub Issues
- **Documentation**: Check `Docs/` folder for detailed guides
- **Setup Help**: See `XCODE_SETUP.md` for detailed setup instructions

### Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Follow Swift style guidelines
4. Submit a pull request

---

## 📚 Additional Documentation

- **[XCODE_SETUP.md](./XCODE_SETUP.md)**: Detailed Xcode setup guide
- **[BUILD_INSTRUCTIONS.md](./BUILD_INSTRUCTIONS.md)**: Build instructions
- **[Docs/Architecture.md](./Docs/Architecture.md)**: Architecture documentation
- **[README_MACOS.md](./README_MACOS.md)**: macOS-specific notes

---

<p align="center">
<strong>Built with ❤️ for macOS users who want to learn smarter, not harder.</strong>
</p>

<p align="center">
Made with SwiftUI • Native Performance • Beautiful Design
</p>
