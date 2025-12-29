//
//  HomeView.swift
//  BananaMeter
//
//  Created on 29/12/2025.
//

import SwiftUI
import GoogleMobileAds

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var showARView = false
    @State private var animateBlobs = false
    @State private var rotateBanana = false
    @State private var funFactIndex = 0
    
    let funFacts = [
        "1 Banana ≈ 7 inches",
        "Potassium Power! ⚡️",
        "For Scale Only 🍌",
        "Perfect Curve ↪️",
        "Yellow & Mellow ☀️"
    ]
    
    // Timer to rotate facts
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // MARK: - Dynamic Background
            if colorScheme == .dark {
                Color(hex: "1A1A1A").ignoresSafeArea() // Premium Dark Grey
            } else {
                Color(hex: "FFD93D").ignoresSafeArea() // Vibrant Yellow
            }
            
            // Floating Blobs (Glow effects)
            GeometryReader { proxy in
                ZStack {
                    Circle()
                        .fill(colorScheme == .dark ? Color(hex: "FFD93D").opacity(0.15) : Color(hex: "FFA41B").opacity(0.6))
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .offset(x: animateBlobs ? -100 : 100, y: animateBlobs ? -150 : -50)
                    
                    Circle()
                        .fill(Color.white.opacity(0.4))
                        .frame(width: 250, height: 250)
                        .blur(radius: 50)
                        .offset(x: animateBlobs ? 150 : -50, y: animateBlobs ? 300 : 100)
                    
                    Circle()
                        .fill(colorScheme == .dark ? Color(hex: "FFA41B").opacity(0.15) : Color(hex: "FFEB3B"))
                        .frame(width: 200, height: 200)
                        .blur(radius: 40)
                        .offset(x: animateBlobs ? -50 : 150, y: animateBlobs ? 100 : 300)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            // MARK: - Raining Bananas
            BananaRainView()
                .ignoresSafeArea() // Cover entire screen including dynamic island/home indicator
                .allowsHitTesting(false) // Let touches pass through to buttons
            
            VStack(spacing: 25) {
                // MARK: - Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Welcome to")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .opacity(0.7)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        Text("BananaMeter")
                            .font(.system(size: 42, weight: .black, design: .rounded))
                            .foregroundStyle(colorScheme == .dark ? Color(hex: "FFD93D") : .white)
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                    }
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                
                Spacer()
                
                // MARK: - Hero Banana (No Background)
                ZStack {
                    // Rotating Ring behind banana
                    Circle()
                        .stroke(lineWidth: 4)
                        .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.1) : Color.white.opacity(0.3))
                        .frame(width: 220, height: 220)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .foregroundStyle(colorScheme == .dark ? Color(hex: "FFD93D") : .white)
                        .frame(width: 220, height: 220)
                        .rotationEffect(.degrees(rotateBanana ? 360 : 0))
                    
                    Text("🍌")
                        .font(.system(size: 140))
                        .scaleEffect(rotateBanana ? 1.1 : 0.9)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)
                }
                .padding(.vertical, 20)
                
                // MARK: - Fun Fact Pill
                HStack(spacing: 12) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(Color(hex: "FFA41B"))
                    
                    Text(funFacts[funFactIndex])
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(colorScheme == .dark ? .white : Color(hex: "8B4513").opacity(0.9))
                        .contentTransition(.numericText())
                        .id("fact_\(funFactIndex)")
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(
                    ZStack {
                        if colorScheme == .dark {
                            Capsule().fill(Color.white.opacity(0.15))
                        } else {
                            Capsule().fill(.ultraThinMaterial)
                        }
                    }
                    .overlay(
                        Capsule()
                            .stroke(colorScheme == .dark ? Color.white.opacity(0.3) : Color.white.opacity(0.6), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(colorScheme == .dark ? 0.3 : 0.05), radius: 5, x: 0, y: 5)
                )
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: funFactIndex)
                
                Spacer()
                
                // MARK: - Features Grid (Bento Style)
                HStack(spacing: 15) {
                    ModernFeatureCard(icon: "ruler.fill", title: "Precise", color: .orange)
                    ModernFeatureCard(icon: "cube.transparent", title: "AR Ready", color: .purple)
                    ModernFeatureCard(icon: "hand.tap.fill", title: "Easy", color: .blue)
                }
                .padding(.horizontal, 30)
                
                // MARK: - Ad Banner
                BannerAd(adUnitID: "ca-app-pub-1465033379713828/7950522997")
                    .frame(height: 50)
                    .padding(.bottom, 10)
                
                // MARK: - Big Action Button
                Button(action: { showARView = true }) {
                    HStack {
                        Image(systemName: "camera.viewfinder")
                            .font(.title2)
                        Text("Start Measuring")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(colorScheme == .dark ? Color(hex: "1A1A1A") : Color(hex: "8B4513"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 65)
                    .background(Color.white) // Keep button white for contrast in both modes
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            }
        }
        .fullScreenCover(isPresented: $showARView) {
            ARMeasurementView()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
                animateBlobs = true
            }
            withAnimation(.linear(duration: 10.0).repeatForever(autoreverses: false)) {
                rotateBanana = true
            }
        }
        .onReceive(timer) { _ in
            withAnimation {
                funFactIndex = (funFactIndex + 1) % funFacts.count
            }
        }
    }
}

struct ModernFeatureCard: View {
    @Environment(\.colorScheme) var colorScheme
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Circle()
                .fill(color.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.title3)
                )
            
            Text(title)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(colorScheme == .dark ? .white.opacity(0.9) : Color(hex: "8B4513").opacity(0.9))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Banana Rain Effect
struct BananaRainView: View {
    @State private var particles: [BananaParticle] = []
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                for particle in particles {
                    // Draw banana with rotation
                    var symbolContext = context
                    let x = particle.x * size.width
                    let y = particle.y * size.height
                    
                    symbolContext.translateBy(x: x, y: y)
                    symbolContext.rotate(by: .degrees(particle.rotation))
                    symbolContext.opacity = particle.opacity
                    
                    let text = Text("🍌").font(.system(size: particle.size))
                    symbolContext.draw(text, at: .zero) // Draw at translated origin
                }
            }
            .onChange(of: timeline.date) { oldValue, newValue in
                updateParticles()
            }
        }
        .onAppear {
            // Initialize particles
            for _ in 0..<30 {
                particles.append(BananaParticle.random())
            }
        }
    }
    
    func updateParticles() {
        for i in 0..<particles.count {
            particles[i].y += particles[i].speed
            particles[i].rotation += 1
            
            // Reset if goes off screen
            if particles[i].y > 1.2 {
                particles[i] = BananaParticle.random(startTop: true)
            }
        }
    }
}

struct BananaParticle {
    var x: Double
    var y: Double
    var speed: Double
    var size: CGFloat
    var rotation: Double
    var opacity: Double
    
    static func random(startTop: Bool = false) -> BananaParticle {
        return BananaParticle(
            x: Double.random(in: 0...1),
            y: startTop ? -0.1 : Double.random(in: 0...1.2),
            speed: Double.random(in: 0.002...0.006), // Falling speed
            size: CGFloat.random(in: 15...35), // Varied sizes
            rotation: Double.random(in: 0...360),
            opacity: Double.random(in: 0.3...0.9) // Varied opacity for depth
        )
    }
}

// MARK: - Safe Banner Ad Implementation
struct BannerAd: View {
    let adUnitID: String
    @State private var isReady = false
    
    var body: some View {
        Group {
            if isReady {
                BannerAdView(adUnitID: adUnitID)
            } else {
                Color.clear
                    .onAppear {
                        // Delay ad loading to prevent blocking UI
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isReady = true
                        }
                    }
            }
        }
    }
}

struct BannerAdView: UIViewRepresentable {
    let adUnitID: String
    
    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: AdSizeBanner)
        banner.adUnitID = adUnitID
        
        // Get root view controller safely  
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            banner.rootViewController = rootViewController
            
            // Load ad asynchronously
            DispatchQueue.main.async {
                let request = Request()
                banner.load(request)
            }
        }
        
        return banner
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) {}
}

// Helper extension for hex colors (re-included for isolated preview support)
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    HomeView()
}
