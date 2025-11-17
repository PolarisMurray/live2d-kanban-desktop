import Foundation
import Combine

/// Loads and manages Live2D model files
@MainActor
public class Live2DModelLoader: ObservableObject {
    // MARK: - Properties
    
    @Published public private(set) var isLoading: Bool = false
    @Published public private(set) var currentModel: LoadedLive2DModel?
    @Published public private(set) var error: Live2DError?
    
    private var cancellables = Set<AnyCancellable>()
    private let modelsDirectory: URL
    
    // MARK: - Types
    
    /// Represents a loaded Live2D model with all required resources
    public struct LoadedLive2DModel {
        public let id: String
        public let name: String
        public let moc3Path: URL
        public let textures: [URL]
        public let motions: [URL]
        public let expressions: [URL]
        public let physicsPath: URL?
        public let posePath: URL?
        
        public init(
            id: String = UUID().uuidString,
            name: String,
            moc3Path: URL,
            textures: [URL],
            motions: [URL],
            expressions: [URL] = [],
            physicsPath: URL? = nil,
            posePath: URL? = nil
        ) {
            self.id = id
            self.name = name
            self.moc3Path = moc3Path
            self.textures = textures
            self.motions = motions
            self.expressions = expressions
            self.physicsPath = physicsPath
            self.posePath = posePath
        }
    }
    
    // Legacy type alias for backwards compatibility
    @available(*, deprecated, renamed: "LoadedLive2DModel")
    public typealias Live2DModel = LoadedLive2DModel
    
    public enum Live2DError: LocalizedError {
        case modelNotFound
        case invalidModelFormat
        case textureLoadFailed
        case motionLoadFailed
        
        public var errorDescription: String? {
            switch self {
            case .modelNotFound:
                return "Live2D model file not found"
            case .invalidModelFormat:
                return "Invalid Live2D model format"
            case .textureLoadFailed:
                return "Failed to load texture files"
            case .motionLoadFailed:
                return "Failed to load motion files"
            }
        }
    }
    
    // MARK: - Initialization
    
    public init(modelsDirectory: URL? = nil) {
        if let directory = modelsDirectory {
            self.modelsDirectory = directory
        } else {
            // Default to Resources/Models directory
            let bundlePath = Bundle.main.resourceURL ?? FileManager.default.temporaryDirectory
            self.modelsDirectory = bundlePath.appendingPathComponent("Models")
        }
    }
    
    // MARK: - Public Methods
    
    /// Loads a Live2D model by name from the models directory
    /// - Parameter modelName: Name of the model directory (e.g., "haru")
    /// - Returns: A LoadedLive2DModel instance if successful
    public func loadModel(named modelName: String) -> LoadedLive2DModel? {
        let modelDirectory = modelsDirectory.appendingPathComponent(modelName)
        return loadModel(from: modelDirectory)
    }
    
    /// Loads a Live2D model from the specified directory
    /// - Parameter modelDirectory: URL to the directory containing the model files
    /// - Returns: A LoadedLive2DModel instance if successful
    public func loadModel(from modelDirectory: URL) -> LoadedLive2DModel? {
        guard FileManager.default.fileExists(atPath: modelDirectory.path) else {
            error = .modelNotFound
            return nil
        }
        
        // Load model.json
        let modelJSONPath = modelDirectory.appendingPathComponent("model.json")
        guard FileManager.default.fileExists(atPath: modelJSONPath.path),
              let jsonData = try? Data(contentsOf: modelJSONPath),
              let modelJSON = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
            error = .invalidModelFormat
            return nil
        }
        
        // Extract model file path
        guard let modelFileName = modelJSON["FileReferences"] as? [String: Any],
              let moc3FileName = modelFileName["Moc"] as? String else {
            error = .invalidModelFormat
            return nil
        }
        
        let moc3Path = modelDirectory.appendingPathComponent(moc3FileName)
        guard FileManager.default.fileExists(atPath: moc3Path.path) else {
            error = .modelNotFound
            return nil
        }
        
        // Extract texture paths
        var textures: [URL] = []
        if let textureFiles = modelFileName["Textures"] as? [String] {
            textures = textureFiles.compactMap { textureName in
                let texturePath = modelDirectory.appendingPathComponent(textureName)
                return FileManager.default.fileExists(atPath: texturePath.path) ? texturePath : nil
            }
        }
        
        // Extract motion paths
        var motions: [URL] = []
        if let motionGroups = modelFileName["Groups"] as? [[String: Any]] {
            for group in motionGroups {
                if let groupTarget = group["Target"] as? String,
                   groupTarget == "Parameter",
                   let groupName = group["Name"] as? String,
                   groupName == "Idle" {
                    // Look for motions in this group
                    if let motionFiles = modelFileName["Motions"] as? [String: [String]] {
                        for (_, motionList) in motionFiles {
                            for motionName in motionList {
                                let motionPath = modelDirectory.appendingPathComponent(motionName)
                                if FileManager.default.fileExists(atPath: motionPath.path) {
                                    motions.append(motionPath)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // Fallback: search for .motion3.json files
        if motions.isEmpty {
            if let motionFiles = modelFileName["Motions"] as? [String: [String]] {
                for (_, motionList) in motionFiles {
                    for motionName in motionList {
                        let motionPath = modelDirectory.appendingPathComponent(motionName)
                        if FileManager.default.fileExists(atPath: motionPath.path) {
                            motions.append(motionPath)
                        }
                    }
                }
            }
        }
        
        // Extract expression paths
        var expressions: [URL] = []
        if let expressionFiles = modelFileName["Expressions"] as? [[String: String]] {
            for expr in expressionFiles {
                if let exprFile = expr["File"] {
                    let exprPath = modelDirectory.appendingPathComponent(exprFile)
                    if FileManager.default.fileExists(atPath: exprPath.path) {
                        expressions.append(exprPath)
                    }
                }
            }
        }
        
        // Extract physics and pose paths (optional)
        let physicsPath: URL? = {
            if let physicsFile = modelFileName["Physics"] as? String {
                let path = modelDirectory.appendingPathComponent(physicsFile)
                return FileManager.default.fileExists(atPath: path.path) ? path : nil
            }
            return nil
        }()
        
        let posePath: URL? = {
            if let poseFile = modelFileName["Pose"] as? String {
                let path = modelDirectory.appendingPathComponent(poseFile)
                return FileManager.default.fileExists(atPath: path.path) ? path : nil
            }
            return nil
        }()
        
        let model = LoadedLive2DModel(
            name: modelDirectory.lastPathComponent,
            moc3Path: moc3Path,
            textures: textures,
            motions: motions,
            expressions: expressions,
            physicsPath: physicsPath,
            posePath: posePath
        )
        
        currentModel = model
        error = nil
        return model
    }
    
    /// Loads a Live2D model from the specified directory (async version)
    /// - Parameter modelDirectory: URL to the directory containing the model files
    /// - Returns: A LoadedLive2DModel instance if successful
    public func load(from modelDirectory: URL) async throws -> LoadedLive2DModel {
        isLoading = true
        error = nil
        
        defer {
            isLoading = false
        }
        
        // Use synchronous loader
        guard let model = loadModel(from: modelDirectory) else {
            let error = self.error ?? Live2DError.modelNotFound
            throw error
        }
        
        return model
    }
    
    /// Unloads the current model
    public func unload() {
        currentModel = nil
        error = nil
    }
}

