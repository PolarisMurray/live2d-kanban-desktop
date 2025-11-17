import Foundation
import Combine
import SwiftUI

/// ViewModel managing chat session with AI
@MainActor
public class ChatSessionViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published public private(set) var messages: [ChatMessage] = []
    @Published public private(set) var isLoading: Bool = false
    @Published public private(set) var error: Error?
    @Published public var inputText: String = ""
    
    // MARK: - Private Properties
    
    private let aiProvider: AIProvider
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    public init(aiProvider: AIProvider) {
        self.aiProvider = aiProvider
    }
    
    // MARK: - Public Methods
    
    /// Sends a message to the AI
    public func send() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !isLoading else {
            return
        }
        
        let userMessage = ChatMessage(
            role: .user,
            content: inputText
        )
        
        messages.append(userMessage)
        let messageToSend = inputText
        inputText = ""
        
        Task {
            await sendMessage(messageToSend)
        }
    }
    
    /// Clears the chat history
    public func clearHistory() {
        messages.removeAll()
        error = nil
    }
    
    // MARK: - Private Methods
    
    private func sendMessage(_ text: String) async {
        isLoading = true
        error = nil
        
        defer {
            isLoading = false
        }
        
        do {
            // Get recent context (last 10 messages for context window)
            let context = Array(messages.suffix(10))
            
            let response = try await aiProvider.sendMessage(text, context: context)
            messages.append(response)
        } catch {
            self.error = error
            
            // Add helpful error message to chat
            var errorMessage = "Sorry, I encountered an error: \(error.localizedDescription)"
            
            // Provide helpful hints for common errors
            if error.localizedDescription.contains("401") || error.localizedDescription.contains("Unauthorized") {
                errorMessage += "\n\n💡 Tip: Please check your API key in Settings (⌘,)"
            } else if error.localizedDescription.contains("network") || error.localizedDescription.contains("connection") {
                errorMessage += "\n\n💡 Tip: Please check your internet connection"
            }
            
            let chatErrorMessage = ChatMessage(
                role: .assistant,
                content: errorMessage
            )
            messages.append(chatErrorMessage)
        }
    }
}

