import Foundation

/// OpenAI API provider implementation
public class OpenAIProvider: AIProvider {
    // MARK: - Properties
    
    private let apiKey: String
    private let baseURL = URL(string: "https://api.openai.com/v1")!
    private let session: URLSession
    
    // MARK: - Initialization
    
    public init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }
    
    // MARK: - AIProvider Protocol
    
    public func sendMessage(_ message: String, context: [ChatMessage]?) async throws -> ChatMessage {
        let endpoint = baseURL.appendingPathComponent("chat/completions")
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Build messages array
        var messages: [[String: String]] = []
        
        // Add system message
        messages.append([
            "role": "system",
            "content": "You are a helpful AI learning companion. Be encouraging, clear, and educational."
        ])
        
        // Add context messages
        if let context = context {
            messages.append(contentsOf: context.map { msg in
                [
                    "role": msg.role.rawValue,
                    "content": msg.content
                ]
            })
        }
        
        // Add current message
        messages.append([
            "role": "user",
            "content": message
        ])
        
        // Create request body
        let requestBody: [String: Any] = [
            "model": "gpt-4",
            "messages": messages,
            "temperature": 0.7,
            "max_tokens": 1000
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        // Perform request
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw AIError.requestFailed
        }
        
        // Parse response
        let decoder = JSONDecoder()
        let apiResponse = try decoder.decode(OpenAIResponse.self, from: data)
        
        guard let firstChoice = apiResponse.choices.first,
              let content = firstChoice.message.content else {
            throw AIError.invalidResponse
        }
        
        return ChatMessage(
            role: .assistant,
            content: content
        )
    }
    
    public func generateFlashcards(from content: String) async throws -> [Flashcard] {
        let prompt = PromptTemplates.flashcardGeneration(content: content)
        let response = try await sendMessage(prompt, context: nil)
        
        // TODO: Parse JSON response into Flashcard array
        // The response should be a JSON array of flashcards
        // Example format: [{"front": "...", "back": "..."}, ...]
        
        return []
    }
    
    public func generateQuestions(from content: String) async throws -> [StudyQuestion] {
        let prompt = PromptTemplates.questionGeneration(content: content)
        let response = try await sendMessage(prompt, context: nil)
        
        // TODO: Parse JSON response into StudyQuestion array
        // The response should be a JSON array of questions
        // Example format: [{"question": "...", "options": [...], "correctAnswer": 0}, ...]
        
        return []
    }
    
    public func explain(topic: String) async throws -> String {
        let prompt = PromptTemplates.explanation(topic: topic)
        let response = try await sendMessage(prompt, context: nil)
        return response.content
    }
}

// MARK: - Response Models

private struct OpenAIResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
    let usage: Usage?
}

private struct Choice: Codable {
    let index: Int
    let message: Message
    let finishReason: String?
    
    enum CodingKeys: String, CodingKey {
        case index
        case message
        case finishReason = "finish_reason"
    }
}

private struct Message: Codable {
    let role: String
    let content: String?
}

private struct Usage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

// MARK: - Error Types

public enum AIError: LocalizedError {
    case invalidAPIKey
    case requestFailed
    case invalidResponse
    case rateLimitExceeded
    case networkError(Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidAPIKey:
            return "Invalid API key"
        case .requestFailed:
            return "Request failed"
        case .invalidResponse:
            return "Invalid response format"
        case .rateLimitExceeded:
            return "Rate limit exceeded"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

