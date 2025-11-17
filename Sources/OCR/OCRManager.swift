import Foundation
import Vision
import CoreGraphics

/// Manages OCR operations using Vision framework
public class OCRManager {
    // MARK: - Types
    
    public enum OCRError: LocalizedError {
        case invalidImage
        case recognitionFailed(Error)
        case noTextFound
        case unsupportedLanguage
        
        public var errorDescription: String? {
            switch self {
            case .invalidImage:
                return "Invalid or corrupted image"
            case .recognitionFailed(let error):
                return "Text recognition failed: \(error.localizedDescription)"
            case .noTextFound:
                return "No text found in image"
            case .unsupportedLanguage:
                return "Unsupported language"
            }
        }
    }
    
    // MARK: - Properties
    
    private let recognitionLanguages: [String]
    
    // MARK: - Initialization
    
    public init(recognitionLanguages: [String] = ["en-US"]) {
        self.recognitionLanguages = recognitionLanguages
    }
    
    // MARK: - Public Methods
    
    /// Extracts text from a CGImage using Vision framework
    /// - Parameter image: The CGImage to process
    /// - Returns: Extracted and cleaned text string
    public func extractText(from image: CGImage) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            // Create text recognition request
            let request = VNRecognizeTextRequest { request, error in
                // Handle errors
                if let error = error {
                    continuation.resume(throwing: OCRError.recognitionFailed(error))
                    return
                }
                
                // Extract text observations
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(throwing: OCRError.noTextFound)
                    return
                }
                
                // Extract text using topCandidates(1) and join with "\n"
                let extractedText = observations.compactMap { observation -> String? in
                    guard let topCandidate = observation.topCandidates(1).first else {
                        return nil
                    }
                    return topCandidate.string
                }.joined(separator: "\n")
                
                // Clean and return text
                let cleanedText = self.cleanText(extractedText)
                
                if cleanedText.isEmpty {
                    continuation.resume(throwing: OCRError.noTextFound)
                } else {
                    continuation.resume(returning: cleanedText)
                }
            }
            
            // Configure request
            request.recognitionLevel = .accurate
            request.recognitionLanguages = recognitionLanguages
            request.usesLanguageCorrection = true
            
            // Perform request
            let handler = VNImageRequestHandler(cgImage: image, options: [:])
            
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: OCRError.recognitionFailed(error))
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Cleans extracted text by removing excessive whitespace and normalizing
    /// - Parameter text: Raw extracted text
    /// - Returns: Cleaned text
    private func cleanText(_ text: String) -> String {
        // Remove leading/trailing whitespace from each line
        let lines = text.components(separatedBy: "\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        // Join lines with single newline
        return lines.joined(separator: "\n")
    }
}

