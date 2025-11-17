# AI Learning Companion - Architecture Documentation

## Overview

The AI Learning Companion is a universal iOS/macOS application built with SwiftUI, following MVVM architecture principles with a modular design for testability and maintainability.

## Architecture Principles

- **MVVM (Model-View-ViewModel)**: Clear separation of concerns
- **Modular Design**: Isolated, testable modules
- **Protocol-Oriented**: Dependency injection via protocols
- **Universal Support**: Single codebase for iOS and macOS

## Module Structure

### 📁 Live2D Module

**Responsibility**: Live2D character rendering and animation management

**Components**:
- `Live2DModelLoader`: Loads and validates Live2D model files (.moc3, textures, motions)
- `Live2DRenderer`: Protocol and Metal-based implementation for rendering Live2D models
- `Live2DStateMachine`: Manages character states (idle, speaking, thinking) and expressions

**Dependencies**: Metal, MetalKit, Foundation

**Testing**: Mock renderer protocol for unit tests

---

### 📁 AIEngine Module

**Responsibility**: AI interaction and content generation

**Components**:
- `AIProvider`: Protocol defining AI capabilities (chat, flashcards, questions, explanations)
- `OpenAIProvider`: Concrete implementation using OpenAI API
- `ChatSessionViewModel`: Manages chat state and message flow
- `PromptTemplates`: Centralized prompt engineering system

**Dependencies**: Foundation, URLSession for networking

**Testing**: Mock AIProvider for testing without API calls

**Key Features**:
- Async/await API design
- Context-aware conversations
- Structured JSON response parsing
- Error handling and retry logic

---

### 📁 OCR Module

**Responsibility**: Text extraction from images

**Components**:
- `OCRManager`: Vision framework wrapper for text recognition

**Dependencies**: Vision, CoreImage, UIKit/AppKit

**Testing**: Mock image data for testing OCR accuracy

**Key Features**:
- Multi-language support
- Platform-agnostic image handling
- Real-time processing with async/await

---

### 📁 StudyModules Module

**Responsibility**: Study tools and learning features

**Components**:
- `Flashcard`: Data model with spaced repetition logic
- `FlashcardGenerator`: AI-powered flashcard creation
- `QuestionGenerator`: Multiple-choice question generation
- `PomodoroViewModel`: Timer management with phase transitions
- `StudyReportGenerator`: PDF report generation using PDFKit

**Dependencies**: Foundation, PDFKit, Combine

**Testing**: Unit tests for timer logic, flashcard algorithms

**Key Features**:
- Spaced repetition algorithm
- Adaptive difficulty
- Performance tracking
- PDF export

---

### 📁 UI Module

**Responsibility**: User interface and app coordination

**Components**:
- `LearningCompanionApp`: App entry point and scene configuration
- `MainView`: Primary navigation and tab management
- `ChatView`: Chat interface with message bubbles
- `FloatingWindow`: Draggable Live2D character window
- `SettingsView`: App configuration and preferences
- `ThemeManager`: Theme and appearance management

**Dependencies**: SwiftUI, Combine

**Testing**: SwiftUI preview testing, snapshot tests

---

## Data Flow

### Chat Flow
```
User Input → ChatView → ChatSessionViewModel → AIProvider → OpenAI API
                                                      ↓
Response ← ChatView ← ChatSessionViewModel ← AIProvider ← JSON Response
```

### Study Session Flow
```
Content → OCRManager → FlashcardGenerator → AIProvider → Flashcards
                                                              ↓
Study → PomodoroViewModel → Performance Tracking → StudyReportGenerator → PDF
```

### Live2D Integration
```
User Action → Live2DStateMachine → State Transition → Live2DRenderer → Metal Rendering
```

## Dependency Injection

All dependencies are injected via protocols:
- `AIProvider` injected into ViewModels
- `Live2DRenderer` injected into StateMachine
- ViewModels injected into Views via `@EnvironmentObject`

## Platform Considerations

### iOS
- Uses `CADisplayLink` for Live2D rendering
- `UIImage` for image handling
- Navigation via `NavigationStack`

### macOS
- Uses `CVDisplayLink` for Live2D rendering
- `NSImage` for image handling
- Navigation via `NavigationSplitView`
- Settings window via `.settings` scene

## Testing Strategy

1. **Unit Tests**: ViewModels, business logic, generators
2. **Integration Tests**: API providers with mock servers
3. **UI Tests**: SwiftUI previews and snapshot tests
4. **Protocol Mocks**: All external dependencies mocked

## Future Enhancements

- [ ] Core Data for persistence
- [ ] CloudKit sync for flashcards
- [ ] Widget extensions
- [ ] Siri Shortcuts integration
- [ ] Apple Watch companion app
- [ ] Advanced Live2D physics and lip-sync

