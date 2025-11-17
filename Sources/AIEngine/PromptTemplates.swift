import Foundation

/// Template system for AI prompts
public enum PromptTemplates {
    
    // MARK: - Flashcard Generation
    
    public static func flashcardGeneration(content: String) -> String {
        return """
        Generate flashcards from the following study material. 
        Return a JSON array where each flashcard has "front" and "back" fields.
        Focus on key concepts, definitions, and important facts.
        
        Study Material:
        \(content)
        
        Return only valid JSON, no additional text.
        """
    }
    
    // MARK: - Question Generation
    
    public static func questionGeneration(content: String) -> String {
        return """
        Generate multiple-choice study questions from the following content.
        Return a JSON array where each question has:
        - "question": the question text
        - "options": array of 4 answer options
        - "correctAnswer": index (0-3) of the correct answer
        - "explanation": brief explanation of why the answer is correct
        
        Content:
        \(content)
        
        Return only valid JSON, no additional text.
        """
    }
    
    // MARK: - Explanation
    
    public static func explanation(topic: String) -> String {
        return """
        Explain the following topic in a clear, educational manner suitable for a student.
        Break down complex concepts into understandable parts.
        Use examples when helpful.
        
        Topic: \(topic)
        """
    }
    
    // MARK: - Study Session Summary
    
    public static func studySummary(flashcards: [Flashcard], questions: [StudyQuestion], performance: StudyPerformance) -> String {
        return """
        Generate a study session summary based on:
        - Number of flashcards reviewed: \(flashcards.count)
        - Number of questions answered: \(questions.count)
        - Performance metrics: \(performance.description)
        
        Provide encouraging feedback and suggestions for improvement.
        """
    }
    
    // MARK: - OCR Content Processing
    
    public static func processOCRContent(_ text: String) -> String {
        return """
        Process and organize the following text extracted from an image.
        Identify key topics, concepts, and important information.
        Format it in a structured way suitable for study.
        
        Extracted Text:
        \(text)
        """
    }
}

// MARK: - Supporting Types

public struct StudyPerformance {
    public let correctAnswers: Int
    public let totalQuestions: Int
    public let timeSpent: TimeInterval
    public let flashcardsReviewed: Int
    
    public var accuracy: Double {
        guard totalQuestions > 0 else { return 0.0 }
        return Double(correctAnswers) / Double(totalQuestions)
    }
    
    public var description: String {
        return "Accuracy: \(Int(accuracy * 100))%, Time: \(Int(timeSpent))s, Flashcards: \(flashcardsReviewed)"
    }
    
    public init(correctAnswers: Int, totalQuestions: Int, timeSpent: TimeInterval, flashcardsReviewed: Int) {
        self.correctAnswers = correctAnswers
        self.totalQuestions = totalQuestions
        self.timeSpent = timeSpent
        self.flashcardsReviewed = flashcardsReviewed
    }
}

