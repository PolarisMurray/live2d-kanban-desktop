import Foundation
import PDFKit
import CoreGraphics
import CoreText

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// Generates PDF study reports
public class StudyReportGenerator {
    // MARK: - Public Methods
    
    /// Generates a weekly study report as a PDF document
    /// - Returns: PDFDocument with at least one page containing text content
    public func generateWeeklyReport() -> PDFDocument {
        let pdfDocument = PDFDocument()
        
        // Create page with standard US Letter size
        let pageSize = CGSize(width: 612, height: 792) // US Letter
        let pageRect = CGRect(origin: .zero, size: pageSize)
        
        // Create a blank page
        let page = PDFPage()
        page.setBounds(pageRect, for: .mediaBox)
        
        // Add page to document
        pdfDocument.insert(page, at: 0)
        
        // Create attributed string for the report content
        let reportText = createWeeklyReportText()
        
        #if canImport(UIKit)
        let font = UIFont.systemFont(ofSize: 12)
        let color = UIColor.black
        #else
        let font = NSFont.systemFont(ofSize: 12)
        let color = NSColor.black
        #endif
        
        let attributedString = NSAttributedString(
            string: reportText,
            attributes: [
                .font: font,
                .foregroundColor: color
            ]
        )
        
        // Draw text on the page using PDFKit's annotation system
        let textRect = CGRect(
            x: 50,
            y: 50,
            width: pageRect.width - 100,
            height: pageRect.height - 100
        )
        
        // Create a free text annotation with the report content
        let annotation = PDFAnnotation(bounds: textRect, forType: .freeText, withProperties: nil)
        annotation.contents = reportText
        annotation.font = font
        annotation.fontColor = color
        page.addAnnotation(annotation)
        
        // For better text rendering, we can also create a data representation
        // and recreate the page with drawn content
        #if canImport(UIKit)
        // On iOS, use UIGraphicsPDFRenderer for better text rendering
        let format = UIGraphicsPDFRendererFormat()
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let pdfData = renderer.pdfData { context in
            context.beginPage()
            
            // Draw text using Core Text
            let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
            let path = CGPath(rect: textRect, transform: nil)
            let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
            
            context.cgContext.saveGState()
            context.cgContext.translateBy(x: 0, y: pageRect.height)
            context.cgContext.scaleBy(x: 1.0, y: -1.0)
            
            CTFrameDraw(frame, context.cgContext)
            
            context.cgContext.restoreGState()
        }
        
        // Replace the document with the rendered version
        if let renderedDocument = PDFDocument(data: pdfData) {
            return renderedDocument
        }
        #else
        // On macOS, use NSGraphicsContext for drawing
        let mutableData = NSMutableData()
        let consumer = CGDataConsumer(data: mutableData as CFMutableData)!
        var mediaBox = pageRect
        let pdfContext = CGContext(consumer: consumer, mediaBox: &mediaBox, nil)!
        
        pdfContext.beginPDFPage(nil)
        pdfContext.setFillColor(NSColor.white.cgColor)
        pdfContext.fill(mediaBox)
        
        // Draw text
        pdfContext.saveGState()
        pdfContext.translateBy(x: 0, y: pageRect.height)
        pdfContext.scaleBy(x: 1.0, y: -1.0)
        
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        let path = CGPath(rect: textRect, transform: nil)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        
        CTFrameDraw(frame, pdfContext)
        
        pdfContext.restoreGState()
        pdfContext.endPDFPage()
        pdfContext.closePDF()
        
        // Create document from rendered data
        if let renderedDocument = PDFDocument(data: mutableData as Data) {
            return renderedDocument
        }
        #endif
        
        return pdfDocument
    }
    
    // MARK: - Private Methods
    
    /// Creates the text content for the weekly report
    private func createWeeklyReportText() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let endDate = Date()
        
        return """
        WEEKLY STUDY REPORT
        
        Period: \(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))
        
        SUMMARY:
        This weekly report summarizes your study activities and progress over the past 7 days.
        
        Key Highlights:
        - Study sessions completed
        - Topics covered
        - Progress made
        - Areas for improvement
        
        RECOMMENDATIONS:
        Continue maintaining consistent study habits and focus on areas that need more attention.
        """
    }
    
    // MARK: - Legacy Methods (kept for compatibility)
    
    /// Generates a PDF report from study session data
    /// - Parameters:
    ///   - performance: Study performance metrics
    ///   - flashcards: Flashcards reviewed
    ///   - questions: Questions answered
    ///   - dateRange: Date range of the study session
    /// - Returns: PDF document data
    public func generateReport(
        performance: StudyPerformance,
        flashcards: [Flashcard],
        questions: [StudyQuestion],
        dateRange: DateInterval
    ) -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "AI Learning Companion",
            kCGPDFContextAuthor: "Study Session Report",
            kCGPDFContextTitle: "Study Report"
        ]
        
        let pageRect = CGRect(origin: .zero, size: pageSize)
        
        #if canImport(UIKit)
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        #else
        // macOS uses NSGraphicsContext for PDF generation
        let mutableData = NSMutableData()
        let consumer = CGDataConsumer(data: mutableData as CFMutableData)!
        var mediaBox = pageRect
        let pdfContext = CGContext(consumer: consumer, mediaBox: &mediaBox, nil)!
        pdfContext.beginPDFPage(nil)
        pdfContext.setFillColor(NSColor.white.cgColor)
        pdfContext.fill(mediaBox)
        #endif
        
        #if canImport(UIKit)
        let data = renderer.pdfData { context in
            context.beginPage()
            
            // Draw header
            drawHeader(in: pageRect, context: context.cgContext)
            
            // Draw performance summary
            let summaryRect = drawPerformanceSummary(
                performance: performance,
                in: pageRect,
                context: context.cgContext
            )
            
            // Draw flashcards section
            let flashcardsRect = drawFlashcardsSection(
                flashcards: flashcards,
                in: pageRect,
                startingY: summaryRect.maxY + 20,
                context: context.cgContext
            )
            
            // Draw questions section
            drawQuestionsSection(
                questions: questions,
                in: pageRect,
                startingY: flashcardsRect.maxY + 20,
                context: context.cgContext
            )
        }
        
        return data
        #else
        // macOS implementation
        drawHeader(in: pageRect, context: pdfContext)
        
        let summaryRect = drawPerformanceSummary(
            performance: performance,
            in: pageRect,
            context: pdfContext
        )
        
        let flashcardsRect = drawFlashcardsSection(
            flashcards: flashcards,
            in: pageRect,
            startingY: summaryRect.maxY + 20,
            context: pdfContext
        )
        
        drawQuestionsSection(
            questions: questions,
            in: pageRect,
            startingY: flashcardsRect.maxY + 20,
            context: pdfContext
        )
        
        pdfContext.endPDFPage()
        pdfContext.closePDF()
        
        return mutableData as Data
        #endif
    }
    
    /// Saves PDF report to file
    /// - Parameters:
    ///   - report: PDF data
    ///   - url: Destination URL
    public func saveReport(_ report: Data, to url: URL) throws {
        try report.write(to: url)
    }
    
    // MARK: - Private Drawing Methods
    
    private func drawHeader(in rect: CGRect, context: CGContext) {
        let title = "Study Session Report"
        #if canImport(UIKit)
        let titleFont = UIFont.boldSystemFont(ofSize: 24)
        let titleColor = UIColor.label
        #else
        let titleFont = NSFont.boldSystemFont(ofSize: 24)
        let titleColor = NSColor.labelColor
        #endif
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: titleColor
        ]
        
        let titleSize = title.size(withAttributes: attributes)
        let titleRect = CGRect(
            x: (rect.width - titleSize.width) / 2,
            y: 40,
            width: titleSize.width,
            height: titleSize.height
        )
        
        title.draw(in: titleRect, withAttributes: attributes)
        
        // Draw date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        let dateString = dateFormatter.string(from: Date())
        #if canImport(UIKit)
        let dateFont = UIFont.systemFont(ofSize: 12)
        let dateColor = UIColor.secondaryLabel
        #else
        let dateFont = NSFont.systemFont(ofSize: 12)
        let dateColor = NSColor.secondaryLabelColor
        #endif
        
        let dateAttributes: [NSAttributedString.Key: Any] = [
            .font: dateFont,
            .foregroundColor: dateColor
        ]
        
        let dateSize = dateString.size(withAttributes: dateAttributes)
        let dateRect = CGRect(
            x: (rect.width - dateSize.width) / 2,
            y: titleRect.maxY + 10,
            width: dateSize.width,
            height: dateSize.height
        )
        
        dateString.draw(in: dateRect, withAttributes: dateAttributes)
    }
    
    private func drawPerformanceSummary(
        performance: StudyPerformance,
        in rect: CGRect,
        context: CGContext
    ) -> CGRect {
        let sectionTitle = "Performance Summary"
        #if canImport(UIKit)
        let titleFont = UIFont.boldSystemFont(ofSize: 18)
        let titleColor = UIColor.label
        let metricFont = UIFont.systemFont(ofSize: 14)
        let metricColor = UIColor.label
        #else
        let titleFont = NSFont.boldSystemFont(ofSize: 18)
        let titleColor = NSColor.labelColor
        let metricFont = NSFont.systemFont(ofSize: 14)
        let metricColor = NSColor.labelColor
        #endif
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: titleColor
        ]
        
        var yPosition: CGFloat = 120
        
        let titleSize = sectionTitle.size(withAttributes: titleAttributes)
        sectionTitle.draw(
            at: CGPoint(x: 50, y: yPosition),
            withAttributes: titleAttributes
        )
        
        yPosition += titleSize.height + 15
        
        // Draw metrics
        let metrics = [
            "Accuracy: \(Int(performance.accuracy * 100))%",
            "Questions Answered: \(performance.totalQuestions)",
            "Correct Answers: \(performance.correctAnswers)",
            "Time Spent: \(formatTimeInterval(performance.timeSpent))",
            "Flashcards Reviewed: \(performance.flashcardsReviewed)"
        ]
        
        let metricAttributes: [NSAttributedString.Key: Any] = [
            .font: metricFont,
            .foregroundColor: metricColor
        ]
        
        for metric in metrics {
            metric.draw(
                at: CGPoint(x: 70, y: yPosition),
                withAttributes: metricAttributes
            )
            yPosition += 20
        }
        
        return CGRect(x: 50, y: 120, width: rect.width - 100, height: yPosition - 120)
    }
    
    private func drawFlashcardsSection(
        flashcards: [Flashcard],
        in rect: CGRect,
        startingY: CGFloat,
        context: CGContext
    ) -> CGRect {
        let sectionTitle = "Flashcards Reviewed"
        #if canImport(UIKit)
        let titleFont = UIFont.boldSystemFont(ofSize: 18)
        let titleColor = UIColor.label
        let cardFont = UIFont.systemFont(ofSize: 12)
        let cardColor = UIColor.label
        #else
        let titleFont = NSFont.boldSystemFont(ofSize: 18)
        let titleColor = NSColor.labelColor
        let cardFont = NSFont.systemFont(ofSize: 12)
        let cardColor = NSColor.labelColor
        #endif
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: titleColor
        ]
        
        var yPosition = startingY
        
        sectionTitle.draw(
            at: CGPoint(x: 50, y: yPosition),
            withAttributes: titleAttributes
        )
        
        yPosition += 30
        
        // Draw flashcards (limit to first 10 for space)
        let flashcardsToShow = Array(flashcards.prefix(10))
        let cardAttributes: [NSAttributedString.Key: Any] = [
            .font: cardFont,
            .foregroundColor: cardColor
        ]
        
        for (index, card) in flashcardsToShow.enumerated() {
            let cardText = "\(index + 1). \(card.question) → \(card.answer)"
            cardText.draw(
                at: CGPoint(x: 70, y: yPosition),
                withAttributes: cardAttributes
            )
            yPosition += 15
            
            // Check if we need a new page
            if yPosition > rect.height - 50 {
                // TODO: Handle page breaks
                break
            }
        }
        
        if flashcards.count > 10 {
            let moreText = "... and \(flashcards.count - 10) more"
            moreText.draw(
                at: CGPoint(x: 70, y: yPosition),
                withAttributes: cardAttributes
            )
            yPosition += 15
        }
        
        return CGRect(x: 50, y: startingY, width: rect.width - 100, height: yPosition - startingY)
    }
    
    private func drawQuestionsSection(
        questions: [StudyQuestion],
        in rect: CGRect,
        startingY: CGFloat,
        context: CGContext
    ) {
        // TODO: Implement questions section drawing
        // Similar structure to flashcards section
    }
    
    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        let seconds = Int(interval) % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }
}

