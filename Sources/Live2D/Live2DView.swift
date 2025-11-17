import SwiftUI
import MetalKit
import Metal

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// SwiftUI wrapper for Live2D MTKView rendering
public struct Live2DView: View {
    @StateObject private var coordinator: Coordinator
    @ObservedObject var stateMachine: Live2DStateMachine
    
    public init(stateMachine: Live2DStateMachine) {
        self._stateMachine = ObservedObject(wrappedValue: stateMachine)
        self._coordinator = StateObject(wrappedValue: Coordinator(stateMachine: stateMachine))
    }
    
    public var body: some View {
        #if canImport(UIKit)
        Live2DViewRepresentable(coordinator: coordinator, stateMachine: stateMachine)
            .onAppear {
                coordinator.renderer?.start()
            }
            .onDisappear {
                coordinator.renderer?.stop()
            }
        #else
        Live2DViewRepresentable(coordinator: coordinator, stateMachine: stateMachine)
            .onAppear {
                coordinator.renderer?.start()
            }
            .onDisappear {
                coordinator.renderer?.stop()
            }
        #endif
    }
    
    // Coordinator to manage renderer lifecycle
    public class Coordinator: ObservableObject {
        var renderer: Live2DRenderer?
        weak var stateMachine: Live2DStateMachine?
        
        init(stateMachine: Live2DStateMachine) {
            self.stateMachine = stateMachine
        }
    }
}

// MARK: - Platform-Specific View Representable

#if canImport(UIKit)
struct Live2DViewRepresentable: UIViewRepresentable {
    @ObservedObject var coordinator: Live2DView.Coordinator
    @ObservedObject var stateMachine: Live2DStateMachine
    
    func makeUIView(context: Context) -> MTKView {
        let mtkView = MTKView()
        
        // Configure MTKView
        mtkView.device = MTLCreateSystemDefaultDevice()
        mtkView.preferredFramesPerSecond = 60
        mtkView.enableSetNeedsDisplay = false
        mtkView.isPaused = false
        mtkView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0) // Transparent
        mtkView.framebufferOnly = false
        
        // Create renderer with this MTKView
        let renderer = Live2DRenderer(mtkView: mtkView)
        coordinator.renderer = renderer
        stateMachine.renderer = renderer
        
        return mtkView
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {
        guard let renderer = coordinator.renderer else { return }
        
        // Sync state machine changes to renderer
        renderer.setExpression(stateMachine.expression)
        
        // Update rendering state
        if stateMachine.currentState != .idle || stateMachine.isSpeaking || stateMachine.isThinking {
            if !renderer.isRendering {
                renderer.start()
            }
        }
    }
}

#elseif canImport(AppKit)
struct Live2DViewRepresentable: NSViewRepresentable {
    @ObservedObject var coordinator: Live2DView.Coordinator
    @ObservedObject var stateMachine: Live2DStateMachine
    
    func makeNSView(context: Context) -> MTKView {
        let mtkView = MTKView()
        
        // Configure MTKView
        mtkView.device = MTLCreateSystemDefaultDevice()
        mtkView.preferredFramesPerSecond = 60
        mtkView.enableSetNeedsDisplay = false
        mtkView.isPaused = false
        mtkView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0) // Transparent
        mtkView.framebufferOnly = false
        
        // Create renderer with this MTKView
        let renderer = Live2DRenderer(mtkView: mtkView)
        coordinator.renderer = renderer
        stateMachine.renderer = renderer
        
        return mtkView
    }
    
    func updateNSView(_ nsView: MTKView, context: Context) {
        guard let renderer = coordinator.renderer else { return }
        
        // Sync state machine changes to renderer
        renderer.setExpression(stateMachine.expression)
        
        // Update rendering state
        if stateMachine.currentState != .idle || stateMachine.isSpeaking || stateMachine.isThinking {
            if !renderer.isRendering {
                renderer.start()
            }
        }
    }
}
#endif

