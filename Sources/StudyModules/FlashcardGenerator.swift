import Foundation

/// Generates flashcards from content using AI
public class FlashcardGenerator {
    // MARK: - Properties
    
    private let aiProvider: AIProvider?
    
    // MARK: - Initialization
    
    public init(aiProvider: AIProvider? = nil) {
        self.aiProvider = aiProvider
    }
    
    // MARK: - Public Methods
    
    /// Generates flashcards from text content
    /// - Parameter text: The text content to generate flashcards from
    /// - Returns: Array of generated flashcards
    public func generate(from text: String) async -> [Flashcard] {
        // Simulate AI processing delay
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // AI prompt structure (mock implementation)
        // In a real implementation, this would call the AI provider:
        // let prompt = PromptTemplates.flashcardGeneration(content: text)
        // let response = try await aiProvider?.generateFlashcards(from: text)
        
        // Generate at least 3 example flashcards based on text content
        let flashcards = generateMockFlashcards(from: text)
        
        return flashcards
    }
    
    // MARK: - Private Methods
    
    /// Generates mock flashcards from text (simulates AI generation)
    private func generateMockFlashcards(from text: String) -> [Flashcard] {
        // Extract key concepts from text (simple keyword extraction)
        let sentences = text.components(separatedBy: ". ")
            .filter { !$0.isEmpty && $0.count > 20 }
        
        var flashcards: [Flashcard] = []
        
        // Generate at least 3 flashcards
        let minCount = 3
        let count = max(minCount, min(sentences.count, 5))
        
        for i in 0..<count {
            let question: String
            let answer: String
            
            if i < sentences.count {
                let sentence = sentences[i]
                // Create question-answer pair
                question = "What is the main concept in: \(sentence.prefix(50))...?"
                answer = sentence.trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                // Generate generic flashcards if not enough sentences
                question = "Key concept \(i + 1) from the study material?"
                answer = "This concept relates to the main topic discussed in the text."
            }
            
            flashcards.append(Flashcard(
                question: question,
                answer: answer
            ))
        }
        
        // Ensure we have at least 3 flashcards
        while flashcards.count < minCount {
            flashcards.append(Flashcard(
                question: "What is an important point from the study material?",
                answer: "An important point that should be remembered for future reference."
            ))
        }
        
        return flashcards
    }
}

