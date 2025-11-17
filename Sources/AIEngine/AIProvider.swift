import Foundation

/// Protocol defining AI provider capabilities
public protocol AIProvider {
    /// Sends a chat message and receives a response
    /// - Parameters:
    ///   - message: The user's message
    ///   - context: Optional conversation context
    /// - Returns: The AI's response
    func sendMessage(_ message: String, context: [ChatMessage]?) async throws -> ChatMessage
    
    /// Generates flashcards from study material
    /// - Parameter content: The content to generate flashcards from
    /// - Returns: Array of generated flashcards
    func generateFlashcards(from content: String) async throws -> [Flashcard]
    
    /// Generates study questions from content
    /// - Parameter content: The content to generate questions from
    /// - Returns: Array of generated questions
    func generateQuestions(from content: String) async throws -> [StudyQuestion]
    
    /// Explains a concept or topic
    /// - Parameter topic: The topic to explain
    /// - Returns: Explanation text
    func explain(topic: String) async throws -> String
}

// MARK: - Supporting Types

public struct ChatMessage: Codable, Identifiable, Equatable {
    public let id: String
    public let role: MessageRole
    public let content: String
    public let timestamp: Date
    
    public init(id: String = UUID().uuidString, role: MessageRole, content: String, timestamp: Date = Date()) {
        self.id = id
        self.role = role
        self.content = content
        self.timestamp = timestamp
    }
}

public enum MessageRole: String, Codable {
    case user
    case assistant
    case system
}

public struct StudyQuestion: Identifiable, Codable {
    public let id: String
    public let question: String
    public let options: [String]
    public let correctAnswer: Int
    public let explanation: String?
    
    public init(id: String = UUID().uuidString, question: String, options: [String], correctAnswer: Int, explanation: String? = nil) {
        self.id = id
        self.question = question
        self.options = options
        self.correctAnswer = correctAnswer
        self.explanation = explanation
    }
}

