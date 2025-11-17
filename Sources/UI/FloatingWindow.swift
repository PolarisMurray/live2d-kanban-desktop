import SwiftUI

public struct FloatingWindow: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @StateObject private var live2DStateMachine = Live2DStateMachine()
    
    @State private var position: CGPoint = CGPoint(x: 100, y: 100)
    @State private var isDragging = false
    @State private var showAskDialog = false
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 8) {
            // Live2D View (width 120)
            Live2DView(stateMachine: live2DStateMachine)
                .frame(width: 120, height: 160)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            // Ask button
            Button("Ask") {
                showAskDialog = true
            }
            .buttonStyle(.borderedProminent)
            .frame(width: 120)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 10)
        .position(position)
        .gesture(
            DragGesture()
                .onChanged { value in
                    if !isDragging {
                        isDragging = true
                    }
                    position = value.location
                }
                .onEnded { _ in
                    isDragging = false
                }
        )
        .sheet(isPresented: $showAskDialog) {
            AskDialogView()
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Close") {
                    dismiss()
                }
            }
        }
    }
}

// MARK: - Ask Dialog View

struct AskDialogView: View {
    @Environment(\.dismiss) var dismiss
    @State private var question: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Ask a question...", text: $question, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3...6)
                    .padding()
                
                Button("Submit") {
                    // TODO: Handle question submission
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(question.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .navigationTitle("Ask AI")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

