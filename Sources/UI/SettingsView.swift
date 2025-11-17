import SwiftUI

public struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var appState: AppState
    
    @AppStorage("apiKey") private var apiKey: String = ""
    @AppStorage("live2DModelPath") private var live2DModelPath: String = ""
    @AppStorage("autoStartPomodoro") private var autoStartPomodoro: Bool = false
    @AppStorage("pomodoroFocusDuration") private var pomodoroFocusDuration: Double = 25 * 60
    @AppStorage("enableFloatingWindow") private var enableFloatingWindow: Bool = false
    
    public init() {}
    
    public var body: some View {
        Form {
            // AI Settings
            Section("AI Configuration") {
                SecureField("OpenAI API Key", text: $apiKey)
                    .textContentType(.password)
                
                Button("Test Connection") {
                    testAIConnection()
                }
            }
            
            // Live2D Settings
            Section("Live2D Character") {
                TextField("Model Path", text: $live2DModelPath)
                
                Button("Load Model") {
                    loadLive2DModel()
                }
            }
            
            // Study Settings
            Section("Study Preferences") {
                Toggle("Auto-start Pomodoro", isOn: $autoStartPomodoro)
                
                Stepper(
                    "Focus Duration: \(Int(pomodoroFocusDuration / 60)) minutes",
                    value: $pomodoroFocusDuration,
                    in: 5...60,
                    step: 5
                )
            }
            
            // Theme Settings
            Section("Appearance") {
                Picker("Theme", selection: $themeManager.colorScheme) {
                    Text("System").tag(ColorScheme?.none)
                    Text("Light").tag(ColorScheme?.some(.light))
                    Text("Dark").tag(ColorScheme?.some(.dark))
                }
                
                Picker("Accent Color", selection: $themeManager.accentColor) {
                    ForEach(ThemeManager.AccentColor.allCases, id: \.self) { color in
                        Label(color.name, systemImage: "circle.fill")
                            .foregroundColor(color.color)
                            .tag(color)
                    }
                }
                
                Toggle("Enable Floating Window", isOn: $enableFloatingWindow)
            }
            
            // About
            Section("About") {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
                
                Link("Documentation", destination: URL(string: "https://github.com/your-repo")!)
            }
        }
        .navigationTitle("Settings")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
    
    // MARK: - Actions
    
    private func testAIConnection() {
        // TODO: Test API key validity
        guard !apiKey.isEmpty else { return }
        
        let provider = OpenAIProvider(apiKey: apiKey)
        appState.currentAIProvider = provider
        
        // TODO: Show success/error alert
    }
    
    private func loadLive2DModel() {
        // TODO: Open file picker and load model
        guard !live2DModelPath.isEmpty else { return }
        
        let modelURL = URL(fileURLWithPath: live2DModelPath)
        // TODO: Load model using Live2DModelLoader
    }
}

