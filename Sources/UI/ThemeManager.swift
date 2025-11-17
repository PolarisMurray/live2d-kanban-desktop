import SwiftUI
import Combine

/// Manages app theme and appearance settings
@MainActor
public class ThemeManager: ObservableObject {
    // MARK: - Published Properties
    
    @Published public var colorScheme: ColorScheme? = nil {
        didSet {
            saveColorScheme()
        }
    }
    
    @Published public var accentColor: AccentColor = .blue {
        didSet {
            saveAccentColor()
        }
    }
    
    @Published public var selectedModelName: String = "default" {
        didSet {
            saveSelectedModelName()
        }
    }
    
    // MARK: - Types
    
    public enum AccentColor: String, CaseIterable {
        case blue
        case purple
        case pink
        case orange
        case green
        case red
        
        public var color: Color {
            switch self {
            case .blue: return .blue
            case .purple: return .purple
            case .pink: return .pink
            case .orange: return .orange
            case .green: return .green
            case .red: return .red
            }
        }
        
        public var name: String {
            rawValue.capitalized
        }
    }
    
    // MARK: - Properties
    
    private let userDefaults = UserDefaults.standard
    private let colorSchemeKey = "app.colorScheme"
    private let accentColorKey = "app.accentColor"
    private let selectedModelNameKey = "app.selectedModelName"
    
    // MARK: - Initialization
    
    public init() {
        loadColorScheme()
        loadAccentColor()
        loadSelectedModelName()
    }
    
    // MARK: - Private Methods
    
    private func loadColorScheme() {
        if let rawValue = userDefaults.string(forKey: colorSchemeKey) {
            switch rawValue {
            case "light":
                colorScheme = .light
            case "dark":
                colorScheme = .dark
            default:
                colorScheme = nil
            }
        }
    }
    
    private func saveColorScheme() {
        let rawValue: String?
        switch colorScheme {
        case .light:
            rawValue = "light"
        case .dark:
            rawValue = "dark"
        case .none:
            rawValue = "system"
        @unknown default:
            rawValue = "system"
        }
        userDefaults.set(rawValue, forKey: colorSchemeKey)
    }
    
    private func loadAccentColor() {
        if let rawValue = userDefaults.string(forKey: accentColorKey),
           let color = AccentColor(rawValue: rawValue) {
            accentColor = color
        }
    }
    
    private func saveAccentColor() {
        userDefaults.set(accentColor.rawValue, forKey: accentColorKey)
    }
    
    private func loadSelectedModelName() {
        if let modelName = userDefaults.string(forKey: selectedModelNameKey) {
            selectedModelName = modelName
        }
    }
    
    private func saveSelectedModelName() {
        userDefaults.set(selectedModelName, forKey: selectedModelNameKey)
    }
}

