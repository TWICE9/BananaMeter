//
//  ARMeasurementView.swift
//  BananaMeter
//
//  Created on 29/12/2025.
//

import SwiftUI
import ARKit
import RealityKit

struct ARMeasurementView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var arViewModel = ARViewModel()
    
    var body: some View {
        ZStack {
            // AR View
            ARViewContainer(arViewModel: arViewModel)
                .edgesIgnoringSafeArea(.all)
            
            // Overlay UI
            VStack {
                // Top Bar
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                
                // Measurement Display (Now at Top)
                if let measurement = arViewModel.currentMeasurement {
                    VStack(spacing: 12) {
                        Text("\(measurement.bananas, specifier: "%.2f") 🍌")
                            .font(.system(size: 56, weight: .black, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: "FFD93D"), Color(hex: "FFA41B")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 2)
                        
                        Text("\(measurement.meters, specifier: "%.2f") meters")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 2)
                        
                        Text("\(measurement.centimeters, specifier: "%.0f") cm · \(measurement.inches, specifier: "%.1f") inches")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                            .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 2)
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 5)
                    )
                    .padding(.horizontal, 30)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: arViewModel.currentMeasurement)
                }
                
                Spacer()
                
                // Capture/Reset button and status
                VStack(spacing: 16) {
                    // Instructions text
                    if arViewModel.measurementPoints.isEmpty {
                        Text("Point at a surface and tap + to start")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 2)
                    } else if arViewModel.measurementPoints.count == 1 {
                        Text("Move to end point and tap +")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 2)
                    }
                    
                    // Main Action Button (Capture OR Reset)
                    Button(action: {
                        if arViewModel.measurementPoints.count < 2 {
                            arViewModel.captureCenterPoint()
                        } else {
                            arViewModel.resetMeasurement()
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 75, height: 75)
                                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                            
                            // Contextual Icon
                            Image(systemName: arViewModel.measurementPoints.count < 2 ? "plus" : "arrow.counterclockwise")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color(hex: "FFD93D"), Color(hex: "FFA41B")],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .transition(.scale)
                        }
                    }
                    .padding(.bottom, 10)
                    
                    // Status indicator
                    HStack(spacing: 8) {
                        Circle()
                            .fill(arViewModel.trackingState == .normal ? Color.green : Color.orange)
                            .frame(width: 8, height: 8)
                        
                        Text(arViewModel.trackingStateDescription)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(.ultraThinMaterial)
                    )
                }
                .padding(.bottom, 50)
            }
            
            // Center crosshair
            if arViewModel.measurementPoints.count < 2 {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 2)
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var arViewModel: ARViewModel
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Configure AR session
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        
        arView.session.run(configuration)
        arView.session.delegate = context.coordinator
        
        arViewModel.arView = arView
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(arViewModel: arViewModel)
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        var arViewModel: ARViewModel
        
        init(arViewModel: ARViewModel) {
            self.arViewModel = arViewModel
        }
        
        func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
            arViewModel.updateTrackingState(camera.trackingState)
        }
    }
}

class ARViewModel: ObservableObject {
    @Published var measurementPoints: [SIMD3<Float>] = []
    @Published var currentMeasurement: Measurement?
    @Published var trackingState: ARCamera.TrackingState = .notAvailable
    
    var arView: ARView?
    private var pointAnchors: [AnchorEntity] = []
    private var lineAnchor: AnchorEntity?
    
    // Standard banana length is approximately 17.78 cm (7 inches)
    private let bananaLength: Float = 0.1778 // meters
    
    var trackingStateDescription: String {
        switch trackingState {
        case .normal:
            return "Tracking Ready"
        case .limited(.initializing):
            return "Initializing..."
        case .limited(.relocalizing):
            return "Relocalizing..."
        case .limited(.insufficientFeatures):
            return "Move device around"
        case .limited(.excessiveMotion):
            return "Move slower"
        case .notAvailable:
            return "Tracking unavailable"
        @unknown default:
            return "Unknown"
        }
    }
    
    func addMeasurementPoint(_ position: SIMD3<Float>) {
        guard measurementPoints.count < 2 else { return }
        
        measurementPoints.append(position)
        addPointMarker(at: position)
        
        if measurementPoints.count == 2 {
            calculateDistance()
            drawLine()
        }
    }
    
    func captureCenterPoint() {
        guard let arView = arView, measurementPoints.count < 2 else { return }
        
        // Get center of screen
        let center = CGPoint(x: arView.bounds.midX, y: arView.bounds.midY)
        
        // Perform raycast from center
        let results = arView.raycast(from: center, allowing: .estimatedPlane, alignment: .any)
        
        if let firstResult = results.first {
            let position = simd_make_float3(firstResult.worldTransform.columns.3)
            addMeasurementPoint(position)
        }
    }
    
    func calculateDistance() {
        guard measurementPoints.count == 2 else { return }
        
        let start = measurementPoints[0]
        let end = measurementPoints[1]
        
        let distance = simd_distance(start, end)
        
        let meters = Double(distance)
        let bananas = meters / Double(bananaLength)
        let centimeters = meters * 100
        let inches = meters * 39.3701
        
        // Update on main thread to ensure UI updates properly
        DispatchQueue.main.async {
            self.currentMeasurement = Measurement(
                meters: meters,
                bananas: bananas,
                centimeters: centimeters,
                inches: inches
            )
        }
    }
    
    func addPointMarker(at position: SIMD3<Float>) {
        guard let arView = arView else { return }
        
        let sphere = MeshResource.generateSphere(radius: 0.01)
        let material = SimpleMaterial(color: UIColor(hex: "FFD93D"), isMetallic: false)
        let entity = ModelEntity(mesh: sphere, materials: [material])
        
        let anchor = AnchorEntity(world: position)
        anchor.addChild(entity)
        arView.scene.addAnchor(anchor)
        pointAnchors.append(anchor)
    }
    
    func drawLine() {
        guard measurementPoints.count == 2, let arView = arView else { return }
        
        let start = measurementPoints[0]
        let end = measurementPoints[1]
        
        // Calculate line properties
        let distance = simd_distance(start, end)
        let midpoint = (start + end) / 2
        
        // Create cylinder for line
        let cylinder = MeshResource.generateBox(width: 0.005, height: distance, depth: 0.005)
        let material = SimpleMaterial(color: UIColor(hex: "FFA41B"), isMetallic: false)
        let entity = ModelEntity(mesh: cylinder, materials: [material])
        
        // Calculate rotation
        let direction = normalize(end - start)
        let up = SIMD3<Float>(0, 1, 0)
        let angle = acos(dot(direction, up))
        let axis = normalize(cross(up, direction))
        
        entity.transform.rotation = simd_quatf(angle: angle, axis: axis)
        
        let anchor = AnchorEntity(world: midpoint)
        anchor.addChild(entity)
        arView.scene.addAnchor(anchor)
        lineAnchor = anchor
    }
    
    func resetMeasurement() {
        // Remove all anchors
        if let arView = arView {
            for anchor in pointAnchors {
                arView.scene.removeAnchor(anchor)
            }
            if let lineAnchor = lineAnchor {
                arView.scene.removeAnchor(lineAnchor)
            }
        }
        
        pointAnchors.removeAll()
        lineAnchor = nil
        measurementPoints.removeAll()
        currentMeasurement = nil
    }
    
    func updateTrackingState(_ state: ARCamera.TrackingState) {
        DispatchQueue.main.async {
            self.trackingState = state
        }
    }
}

struct Measurement: Equatable {
    let meters: Double
    let bananas: Double
    let centimeters: Double
    let inches: Double
}

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue:  CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
}

#Preview {
    ARMeasurementView()
}
