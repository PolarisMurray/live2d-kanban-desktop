import Foundation
import MetalKit
import Combine

#if canImport(UIKit)
import UIKit
import QuartzCore
#elseif canImport(AppKit)
import AppKit
import CoreVideo
#endif

/// Protocol defining Live2D rendering capabilities
public protocol Live2DRendererProtocol: AnyObject {
    var isRendering: Bool { get }
    var frameRate: Double { get set }
    
    func start()
    func stop()
    func draw(in view: MTKView)
    func updateModel(_ model: Live2DModelLoader.LoadedLive2DModel)
    func playMotion(at path: URL)
    func setExpression(_ expression: String)
}

/// Metal-based Live2D renderer implementation
public class Live2DRenderer: NSObject, Live2DRendererProtocol, MTKViewDelegate {
    // MARK: - Properties
    
    public var isRendering: Bool = false
    public var frameRate: Double = 60.0 {
        didSet {
            mtkView?.preferredFramesPerSecond = Int(frameRate)
        }
    }
    
    private weak var mtkView: MTKView?
    private var device: MTLDevice?
    private var commandQueue: MTLCommandQueue?
    private var renderPipelineState: MTLRenderPipelineState?
    private var currentModel: Live2DModelLoader.LoadedLive2DModel?
    
    // MARK: - Initialization
    
    public init(mtkView: MTKView) {
        super.init()
        self.mtkView = mtkView
        setupMetal()
        configureMTKView()
    }
    
    // MARK: - Setup
    
    private func setupMetal() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported on this device")
        }
        
        self.device = device
        self.commandQueue = device.makeCommandQueue()
        
        // TODO: Create render pipeline state for Live2D rendering
        // This will be configured once Cubism SDK is integrated
        setupRenderPipeline()
    }
    
    private func configureMTKView() {
        guard let mtkView = mtkView, let device = device else { return }
        
        mtkView.device = device
        mtkView.delegate = self
        mtkView.preferredFramesPerSecond = Int(frameRate)
        mtkView.enableSetNeedsDisplay = false
        mtkView.isPaused = false
        mtkView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0) // Transparent
        mtkView.framebufferOnly = false
    }
    
    private func setupRenderPipeline() {
        guard let device = device,
              let library = device.makeDefaultLibrary() else {
            return
        }
        
        // TODO: Integrate Cubism renderer
        // For now, create a basic pipeline as placeholder
        // This will be replaced with Cubism-specific shaders
        
        let vertexFunction = library.makeFunction(name: "vertex_main")
        let fragmentFunction = library.makeFunction(name: "fragment_main")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
        pipelineDescriptor.colorAttachments[0].rgbBlendOperation = .add
        pipelineDescriptor.colorAttachments[0].alphaBlendOperation = .add
        pipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha
        pipelineDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .sourceAlpha
        pipelineDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
        pipelineDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha
        
        do {
            renderPipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            print("Failed to create render pipeline state: \(error)")
        }
    }
    
    // MARK: - Live2DRendererProtocol
    
    public func start() {
        guard !isRendering else { return }
        isRendering = true
        mtkView?.isPaused = false
    }
    
    public func stop() {
        guard isRendering else { return }
        isRendering = false
        mtkView?.isPaused = true
    }
    
    public func updateModel(_ model: Live2DModelLoader.LoadedLive2DModel) {
        currentModel = model
        // TODO: Integrate Cubism renderer
        // 1. Parse .moc3 file using Cubism SDK
        // 2. Create vertex buffers from model data
        // 3. Load textures into Metal textures
        // 4. Set up Cubism render pipeline
        // 5. Initialize model parameters and parts
    }
    
    public func playMotion(at path: URL) {
        // TODO: Integrate Cubism motion playback
        // 1. Load motion file using Cubism SDK
        // 2. Parse motion keyframes
        // 3. Apply to model parameters via Cubism API
        // 4. Start motion playback queue
    }
    
    public func setExpression(_ expression: String) {
        // TODO: Integrate Cubism expression system
        // 1. Look up expression parameters in model
        // 2. Interpolate to target values using Cubism API
        // 3. Apply expression blend weights
    }
    
    // MARK: - MTKViewDelegate
    
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // TODO: Handle view size changes
        // Update projection matrix for Live2D rendering
        // Cubism SDK typically uses orthographic projection
    }
    
    public func draw(in view: MTKView) {
        guard isRendering,
              let device = device,
              let commandQueue = commandQueue,
              let renderPipelineState = renderPipelineState,
              let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        
        // Create command buffer
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            return
        }
        
        // Begin render pass
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            return
        }
        
        renderEncoder.setRenderPipelineState(renderPipelineState)
        
        // TODO: Integrate Cubism renderer
        // 1. Update model parameters (physics, motion, expression)
        // 2. Call Cubism rendering API to draw model
        // 3. Cubism will handle vertex buffer updates and drawing
        
        // Placeholder: Clear with transparent background
        renderEncoder.endEncoding()
        
        // Present drawable
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

