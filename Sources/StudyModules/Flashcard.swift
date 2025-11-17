import Foundation

/// Represents a study flashcard
public struct Flashcard: Identifiable, Codable, Equatable {
    public let id: String
    public let question: String
    public let answer: String
    
    // MARK: - Initialization
    
    public init(
        id: String = UUID().uuidString,
        question: String,
        answer: String
    ) {
        self.id = id
        self.question = question
        self.answer = answer
    }
}

