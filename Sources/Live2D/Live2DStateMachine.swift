import Foundation
import Combine
import SwiftUI

/// Manages Live2D character state and animations
@MainActor
public class Live2DStateMachine: ObservableObject {
    // MARK: - Published Properties
    
    @Published public private(set) var currentState: CharacterState = .idle
    @Published public var expression: String = "neutral"
    @Published public private(set) var isSpeaking: Bool = false
    @Published public private(set) var isThinking: Bool = false
    
    // MARK: - State Types
    
    public enum CharacterState: String, CaseIterable {
        case idle
        case focus
        case happy
        case warning
        case listening
        case speaking
        case thinking
        case celebrating
        case confused
        case sleeping
        case studying
        
        public var motionFile: String? {
            switch self {
            case .idle: return "idle.motion3.json"
            case .focus: return "tap.motion3.json"
            case .happy: return "flick_head.motion3.json"
            case .warning: return "shake.motion3.json"
            case .listening: return "tap.motion3.json"
            case .speaking: return "tap.motion3.json"
            case .thinking: return "shake.motion3.json"
            case .celebrating: return "flick_head.motion3.json"
            case .confused: return "shake.motion3.json"
            case .sleeping: return "idle.motion3.json"
            case .studying: return "tap.motion3.json"
            }
        }
    }
    
    // Legacy enum for backwards compatibility
    @available(*, deprecated, renamed: "CharacterState")
    public typealias State = CharacterState
    
    public enum Expression: String, CaseIterable {
        case neutral
        case happy
        case sad
        case surprised
        case angry
        case focused
        case tired
        
        public var expressionFile: String? {
            switch self {
            case .neutral: return "f01.exp3.json"
            case .happy: return "f02.exp3.json"
            case .sad: return "f03.exp3.json"
            case .surprised: return "f04.exp3.json"
            case .angry: return "f05.exp3.json"
            case .focused: return "f06.exp3.json"
            case .tired: return "f07.exp3.json"
            }
        }
    }
    
    // MARK: - Private Properties
    
    private var stateTimer: Timer?
    private var expressionTimer: Timer?
    public var renderer: Live2DRendererProtocol?
    
    // MARK: - Initialization
    
    public init(renderer: Live2DRendererProtocol? = nil) {
        self.renderer = renderer
    }
    
    // MARK: - Public Methods
    
    /// Transitions to a new state
    public func transition(to newState: CharacterState) {
        guard newState != currentState else { return }
        
        currentState = newState
        
        // Update derived properties
        isSpeaking = (newState == .speaking)
        isThinking = (newState == .thinking)
        
        // Update expression based on state
        updateExpressionForState(newState)
        
        // Play state-specific motion
        if let motionFile = newState.motionFile {
            // TODO: Load and play motion file using model's motion paths
            renderer?.playMotion(at: URL(fileURLWithPath: motionFile))
        }
        
        // Auto-transition back to idle after certain states
        if newState == .celebrating || newState == .confused {
            scheduleStateTransition(to: .idle, after: 3.0)
        }
    }
    
    /// Updates state based on Pomodoro timer status
    /// - Parameter pomodoroStatus: Current Pomodoro phase and status
    public func updateState(basedOn pomodoroStatus: PomodoroStatus) {
        switch pomodoroStatus {
        case .focus(let isRunning):
            if isRunning {
                transition(to: .focus)
                expression = "focused"
            } else {
                transition(to: .idle)
                expression = "neutral"
            }
        case .shortBreak(let isRunning):
            if isRunning {
                transition(to: .happy)
                expression = "happy"
            } else {
                transition(to: .idle)
                expression = "neutral"
            }
        case .longBreak(let isRunning):
            if isRunning {
                transition(to: .happy)
                expression = "happy"
            } else {
                transition(to: .idle)
                expression = "neutral"
            }
        case .completed:
            transition(to: .celebrating)
            expression = "happy"
        case .warning(let timeRemaining):
            // Show warning when less than 1 minute remaining
            if timeRemaining < 60 {
                transition(to: .warning)
                expression = "surprised"
            }
        }
    }
    
    /// Sets a new expression
    public func setExpression(_ expression: Expression, duration: TimeInterval = 0.5) {
        guard Expression(rawValue: self.expression) != expression else { return }
        
        self.expression = expression.rawValue
        
        // Apply expression to renderer
        renderer?.setExpression(expression.rawValue)
        
        // Auto-reset to neutral after duration
        if expression != .neutral {
            scheduleExpressionReset(after: duration)
        }
    }
    
    /// Sets expression by string name
    public func setExpression(_ expressionString: String) {
        expression = expressionString
        renderer?.setExpression(expressionString)
    }
    
    // MARK: - Private Methods
    
    private func updateExpressionForState(_ state: CharacterState) {
        switch state {
        case .idle:
            expression = "neutral"
        case .focus, .studying:
            expression = "focused"
        case .happy, .celebrating:
            expression = "happy"
        case .warning, .confused:
            expression = "surprised"
        case .sleeping:
            expression = "tired"
        case .listening, .speaking, .thinking:
            expression = "focused"
        }
    }
    
    /// Triggers a quick reaction animation
    public func react(to event: ReactionEvent) {
        switch event {
        case .correctAnswer:
            setExpression(.happy, duration: 2.0)
            transition(to: .celebrating)
        case .wrongAnswer:
            setExpression(.sad, duration: 1.5)
            transition(to: .confused)
        case .newQuestion:
            setExpression(.focused, duration: 1.0)
            transition(to: .listening)
        case .studyComplete:
            setExpression(.happy, duration: 3.0)
            transition(to: .celebrating)
        case .tired:
            setExpression(.tired, duration: 2.0)
            transition(to: .sleeping)
        }
    }
    
    private func scheduleStateTransition(to state: CharacterState, after delay: TimeInterval) {
        stateTimer?.invalidate()
        let targetState = state
        stateTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            Task { @MainActor in
                self?.transition(to: targetState)
            }
        }
    }
    
    private func scheduleExpressionReset(after delay: TimeInterval) {
        expressionTimer?.invalidate()
        expressionTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            Task { @MainActor in
                self?.setExpression("neutral")
            }
        }
    }
}

// MARK: - Supporting Types

public enum ReactionEvent {
    case correctAnswer
    case wrongAnswer
    case newQuestion
    case studyComplete
    case tired
}

public enum PomodoroStatus {
    case focus(isRunning: Bool)
    case shortBreak(isRunning: Bool)
    case longBreak(isRunning: Bool)
    case completed
    case warning(timeRemaining: TimeInterval)
}

