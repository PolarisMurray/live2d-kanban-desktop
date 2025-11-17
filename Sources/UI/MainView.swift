import SwiftUI

public struct MainView: View {
    @AppStorage("apiKey") private var apiKey: String = ""
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var appState: AppState
    @StateObject private var chatViewModel: ChatSessionViewModel
    @StateObject private var pomodoroViewModel = PomodoroViewModel()
    @StateObject private var live2DStateMachine = Live2DStateMachine()
    
    @State private var showFloatingWindow = false
    @State private var showOCR = false
    @State private var showFlashcards = false
    @State private var showPomodoro = false
    
    // MARK: - Initialization
    
    public init() {
        // Initialize with API key from UserDefaults
        let storedApiKey = UserDefaults.standard.string(forKey: "apiKey") ?? ""
        let provider = OpenAIProvider(apiKey: storedApiKey)
        _chatViewModel = StateObject(wrappedValue: ChatSessionViewModel(aiProvider: provider))
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: 0) {
            // Live2D View (height 200)
            ZStack {
                Live2DView(stateMachine: live2DStateMachine)
                    .frame(height: 200)
                
                // Placeholder when no model is loaded
                VStack(spacing: 8) {
                    Image(systemName: "person.crop.circle.badge.questionmark")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("Live2D Character")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("Load a model in Settings (⌘,)")
                        .font(.caption)
                        .foregroundColor(.secondary.opacity(0.7))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.05))
            }
            .frame(height: 200)
            
            // Action Buttons
            HStack(spacing: 16) {
                Button("Ask AI") {
                    // Focus on chat input or show chat
                }
                .buttonStyle(.borderedProminent)
                .help("Start a conversation with AI (requires API key in Settings)")
                
                Button("OCR") {
                    showOCR = true
                }
                .buttonStyle(.bordered)
                
                Button("Flashcards") {
                    showFlashcards = true
                }
                .buttonStyle(.bordered)
                
                Button("Pomodoro") {
                    showPomodoro = true
                }
                .buttonStyle(.bordered)
            }
            .padding()
            
            // Chat View
            ChatView()
                .environmentObject(chatViewModel)
        }
        .sheet(isPresented: $showFloatingWindow) {
            FloatingWindow()
                .environmentObject(appState)
        }
        .sheet(isPresented: $showOCR) {
            OCRView()
        }
        .sheet(isPresented: $showFlashcards) {
            FlashcardView()
        }
        .sheet(isPresented: $showPomodoro) {
            PomodoroView()
                .environmentObject(pomodoroViewModel)
            #if os(macOS)
                .frame(minWidth: 500, minHeight: 400)
            #endif
        }
    }
}

// MARK: - Supporting Views

struct OCRView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("OCR View")
                    .font(.title)
                    .padding()
                Text("Image text extraction will be implemented here")
                    .foregroundColor(.secondary)
            }
            .navigationTitle("OCR")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct PomodoroView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var pomodoroViewModel: PomodoroViewModel
    
    var body: some View {
        #if os(macOS)
        VStack(spacing: 30) {
            // Title
            Text("Pomodoro Timer")
                .font(.largeTitle)
                .bold()
                .padding(.top)
            
            // Timer Display
            VStack(spacing: 10) {
                Text(formatTime(pomodoroViewModel.secondsRemaining))
                    .font(.system(size: 72, weight: .bold, design: .monospaced))
                    .foregroundColor(pomodoroViewModel.isRunning ? .primary : .secondary)
                
                // Progress indicator
                ProgressView(value: Double(1500 - pomodoroViewModel.secondsRemaining), total: 1500)
                    .progressViewStyle(.linear)
                    .frame(width: 300)
            }
            .padding()
            
            // Control Buttons
            HStack(spacing: 20) {
                if pomodoroViewModel.isRunning {
                    Button(action: {
                        pomodoroViewModel.pause()
                    }) {
                        Label("Pause", systemImage: "pause.fill")
                            .frame(width: 120)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                } else {
                    Button(action: {
                        pomodoroViewModel.start()
                    }) {
                        Label("Start", systemImage: "play.fill")
                            .frame(width: 120)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                
                Button(action: {
                    pomodoroViewModel.reset()
                }) {
                    Label("Reset", systemImage: "arrow.clockwise")
                        .frame(width: 120)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
            .padding(.bottom, 30)
            
            // Status
            if pomodoroViewModel.isRunning {
                HStack {
                    Image(systemName: "circle.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                    Text("Running")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } else if pomodoroViewModel.secondsRemaining < 1500 {
                HStack {
                    Image(systemName: "pause.circle.fill")
                        .foregroundColor(.orange)
                        .font(.caption)
                    Text("Paused")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Close button
            Button("Close") {
                dismiss()
            }
            .buttonStyle(.bordered)
            .padding(.bottom)
        }
        .frame(width: 500, height: 400)
        .padding()
        #else
        NavigationView {
            VStack(spacing: 30) {
                Text("Pomodoro Timer")
                    .font(.largeTitle)
                    .bold()
                
                Text(formatTime(pomodoroViewModel.secondsRemaining))
                    .font(.system(size: 72, weight: .bold, design: .monospaced))
                
                HStack(spacing: 20) {
                    if pomodoroViewModel.isRunning {
                        Button("Pause") {
                            pomodoroViewModel.pause()
                        }
                        .buttonStyle(.borderedProminent)
                    } else {
                        Button("Start") {
                            pomodoroViewModel.start()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                    Button("Reset") {
                        pomodoroViewModel.reset()
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
            .navigationTitle("Pomodoro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
        #endif
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}

struct FlashcardView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Flashcard View")
                    .font(.title)
                    .padding()
                Text("Flashcard review interface will be implemented here")
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Flashcards")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

