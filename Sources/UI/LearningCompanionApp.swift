import SwiftUI

@main
public struct LearningCompanionApp: App {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var appState = AppState()
    
    public init() {}
    
    public var body: some Scene {
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

// MARK: - App State

@MainActor
public class AppState: ObservableObject {
    @Published public var currentAIProvider: AIProvider?
    @Published public var live2DRenderer: Live2DRendererProtocol?
    @Published public var live2DStateMachine: Live2DStateMachine?
    
    public init() {
        // TODO: Initialize with default provider
        // Load API key from keychain/user defaults
    }
}

