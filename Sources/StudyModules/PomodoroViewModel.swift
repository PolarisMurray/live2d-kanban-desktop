import Foundation
import Combine
import SwiftUI

/// ViewModel managing Pomodoro timer functionality
@MainActor
public class PomodoroViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published public var secondsRemaining: Int = 1500 // 25 minutes in seconds
    @Published public var isRunning: Bool = false
    
    // MARK: - Private Properties
    
    private var timerCancellable: AnyCancellable?
    
    // MARK: - Initialization
    
    public init() {
        // Initialize with 1500 seconds (25 minutes)
        secondsRemaining = 1500
    }
    
    // MARK: - Public Methods
    
    /// Starts the timer
    public func start() {
        guard !isRunning else { return }
        
        isRunning = true
        
        // Use Timer.publish(every: 1, on: .main, in: .common)
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }
    
    /// Pauses the timer
    public func pause() {
        guard isRunning else { return }
        
        isRunning = false
        timerCancellable?.cancel()
        timerCancellable = nil
    }
    
    /// Resets the timer to initial duration (1500 seconds)
    public func reset() {
        isRunning = false
        timerCancellable?.cancel()
        timerCancellable = nil
        secondsRemaining = 1500
    }
    
    // MARK: - Private Methods
    
    private func tick() {
        guard secondsRemaining > 0 else {
            // Timer completed
            pause()
            return
        }
        
        secondsRemaining -= 1
    }
}

