import SwiftUI
import CoreHaptics

// MARK: - Animated Text Component
struct AnimatedTextCycler: View {
    let texts: [String]
    let transitionDuration: Double
    let displayDuration: Double
    
    @State private var currentIndex = 0
    @State private var opacity: Double = 1
    @State private var offset: CGFloat = 0
    @State private var previousText: String = ""
    @State private var currentText: String = ""
    
    init(texts: [String], transitionDuration: Double = 0.5, displayDuration: Double = 2.0) {
        self.texts = texts
        self.transitionDuration = transitionDuration
        self.displayDuration = displayDuration
        _currentText = State(initialValue: texts.first ?? "")
    }
    
    var body: some View {
        ZStack {
            // Previous text for smooth transition
            Text(previousText)
                .font(.title2.weight(.semibold))
                .foregroundColor(.white)
                .opacity(1 - opacity)
                .offset(y: -offset)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .white.opacity(0.9), .clear]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .opacity(1 - opacity)
                )
                .mask(
                    Text(previousText)
                        .font(.title2.weight(.semibold))
                )
            
            // Current text
            Text(currentText)
                .font(.title2.weight(.semibold))
                .foregroundColor(.white)
                .opacity(opacity)
                .offset(y: offset)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .white.opacity(0.9), .clear]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .opacity(opacity)
                )
                .mask(
                    Text(currentText)
                        .font(.title2.weight(.semibold))
                )
        }
        .onAppear {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        guard !texts.isEmpty else { return }
        
        Timer.scheduledTimer(withTimeInterval: displayDuration, repeats: true) { _ in
            // Store current text as previous
            previousText = currentText
            
            // Update index
            currentIndex = (currentIndex + 1) % texts.count
            
            // Animate transition
            withAnimation(.easeInOut(duration: transitionDuration)) {
                opacity = 0
                offset = 20
            }
            
            // After half the transition, update the text
            DispatchQueue.main.asyncAfter(deadline: .now() + (transitionDuration / 2)) {
                currentText = texts[currentIndex]
                
                // Animate new text in
                withAnimation(.easeInOut(duration: transitionDuration)) {
                    opacity = 1
                    offset = 0
                }
            }
        }
    }
}

// MARK: - Animated Progress Bar
struct AnimatedProgressBar: View {
    let progress: Double
    let barHeight: CGFloat = 6
    @State private var shimmerOffset: CGFloat = -0.7
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background bar
                RoundedRectangle(cornerRadius: barHeight / 2)
                    .fill(Color.white.opacity(0.1))
                    .frame(height: barHeight)
                
                // Progress bar
                RoundedRectangle(cornerRadius: barHeight / 2)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.7),
                                Color.white.opacity(0.9)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * CGFloat(progress), height: barHeight)
                    .overlay(
                        // Shimmer effect
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .clear,
                                .white.opacity(0.5),
                                .clear
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .offset(x: geometry.size.width * shimmerOffset)
                    )
                    .mask(
                        RoundedRectangle(cornerRadius: barHeight / 2)
                            .frame(width: geometry.size.width * CGFloat(progress), height: barHeight)
                    )
            }
            .onAppear {
                withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                    shimmerOffset = 1.7
                }
            }
        }
    }
}

// MARK: - Resource Management
final class LoadingViewManager: ObservableObject {
    @Published var particles: [ParticleState] = []
    private var particleTimer: Timer?
    private var hapticEngine: CHHapticEngine?
    
    deinit {
        particleTimer?.invalidate()
        hapticEngine?.stop()
    }
    
    func startParticleSystem() {
        // Limit particle updates to reduce CPU usage
        particleTimer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.updateParticles()
        }
    }
    
    private func updateParticles() {
        let screenSize = UIScreen.main.bounds.size
        
        // Limit maximum particles
        if particles.count < 20 {
            let particle = ParticleState(
                position: CGPoint(
                    x: CGFloat.random(in: 0...screenSize.width),
                    y: CGFloat.random(in: 0...screenSize.height)
                ),
                scale: CGFloat.random(in: 0.3...0.8),
                opacity: Double.random(in: 0.3...0.7),
                rotation: Double.random(in: 0...360)
            )
            particles.append(particle)
        }
        
        // Batch update particles
        particles = particles.compactMap { particle in
            var updatedParticle = particle
            updatedParticle.position.y -= 2
            updatedParticle.opacity -= 0.02
            updatedParticle.rotation += 5
            return updatedParticle.opacity > 0 ? updatedParticle : nil
        }
    }
    
    func setupHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
            
            // Reduced number of haptic events
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.4)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
            
            let events = (0...4).map { i -> CHHapticEvent in
                CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [intensity, sharpness],
                    relativeTime: TimeInterval(i) * 1.0
                )
            }
            
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try hapticEngine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Haptic error: \(error)")
        }
    }
}

struct BackgroundEffect: View {
    @State private var gradientRotation = 0.0
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(.black).opacity(0.6),
                Color(.gray).opacity(0.6),
                Color(.brown).opacity(0.6),
                Color(.indigo).opacity(0.6),
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .hueRotation(.degrees(gradientRotation))
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.linear(duration: 12).repeatForever(autoreverses: false)) {
                gradientRotation = 360
            }
        }
    }
}

// MARK: - Ambient Light Effect
struct AmbientLight: View {
    @State private var animationPhase: CGFloat = 0
    
    let position: CGPoint
    let baseSize: CGFloat
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                context.addFilter(.blur(radius: 30))
                
                let timeNow = timeline.date.timeIntervalSinceReferenceDate
                let angle = timeNow.remainder(dividingBy: 2)
                let offset = CGFloat(sin(angle * .pi)) * 10
                
                let rect = CGRect(x: position.x - baseSize/2,
                                y: position.y - baseSize/2 + offset,
                                width: baseSize,
                                height: baseSize)
                
                context.opacity = 0.5 + (CGFloat(sin(timeNow)) * 0.1)
                
                let gradient = Gradient(colors: [
                    .white.opacity(0.3),
                    .clear
                ])
                
                context.drawLayer { ctx in
                    ctx.fill(Path(ellipseIn: rect),
                            with: .linearGradient(gradient,
                                                startPoint: CGPoint(x: rect.minX, y: rect.minY),
                                                endPoint: CGPoint(x: rect.maxX, y: rect.maxY)))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// MARK: - Enhanced Progress Ring
struct ProgressRing: View {
    let progress: Double
    let size: CGFloat
    @State private var ringRotation = 0.0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.15), lineWidth: 14)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            .white.opacity(0.6),
                            .white
                        ]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 14, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .rotationEffect(.degrees(ringRotation))
                .animation(.linear(duration: 2.5).repeatForever(autoreverses: false), value: ringRotation)
                .onAppear {
                    ringRotation = 360
                }
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Main View with Improved Performance
struct AIGenerationLoadingView: View {
    @StateObject private var manager = LoadingViewManager()
    @State private var progressValue: Double = 0
    @State private var pulseAnimation = false
    @State private var rotationAnimation = false
    @State private var sparkleScale: CGFloat = 1
    @State private var progressBarValue: Double = 0
    
    var body: some View {
        ZStack {
            BackgroundEffect()
            
            // Ambient light effects
            Group {
                AmbientLight(
                    position: CGPoint(x: UIScreen.main.bounds.width * 0.25,
                                    y: UIScreen.main.bounds.height * 0.3),
                    baseSize: 120
                )
                AmbientLight(
                    position: CGPoint(x: UIScreen.main.bounds.width * 0.75,
                                    y: UIScreen.main.bounds.height * 0.7),
                    baseSize: 140
                )
            }
            
            // Particles with improved performance
            ForEach(manager.particles) { particle in
                Image(systemName: "sparkle")
                    .foregroundColor(.white)
                    .scaleEffect(particle.scale)
                    .opacity(particle.opacity)
                    .position(particle.position)
                    .rotationEffect(.degrees(particle.rotation))
            }
            
            VStack(spacing: 45) {
                ZStack {
                    ProgressRing(progress: progressValue, size: 240)
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [.white.opacity(0.7), .clear]),
                                center: .center,
                                startRadius: 5,
                                endRadius: 90
                            )
                        )
                        .frame(width: 180, height: 180)
                        .scaleEffect(pulseAnimation ? 1.2 : 0.8)
                        .opacity(pulseAnimation ? 0.6 : 0.9)
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 44, weight: .medium))
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(rotationAnimation ? 360 : 0))
                        .scaleEffect(sparkleScale)
                }
                
                VStack(spacing: 20) {
                    AnimatedTextCycler(
                        texts: [
                            "Creating something amazing...",
                            "Crafting your experience...",
                            "Processing with AI...",
                            "Almost there...",
                            "Making magic happen..."
                        ],
                        transitionDuration: 0.7,
                        displayDuration: 2.5
                    )
                    
                    // Progress Bar
                    AnimatedProgressBar(progress: progressBarValue)
                        .frame(width: 280, height: 6)
                }
            }
        }
        .onAppear {
            startAnimations()
            manager.setupHaptics()
            manager.startParticleSystem()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 3.5).repeatForever(autoreverses: false)) {
            progressValue = 1.0
        }
        
        withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
            pulseAnimation = true
        }
        
        withAnimation(.linear(duration: 4.5).repeatForever(autoreverses: false)) {
            rotationAnimation = true
        }
        
        withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
            sparkleScale = 1.25
        }
        
        // Animate progress bar
        withAnimation(.easeInOut(duration: 8.0)) {
            progressBarValue = 1.0
        }
    }
}

// MARK: - Supporting Types
struct ParticleState: Identifiable {
    let id = UUID()
    var position: CGPoint
    var scale: CGFloat
    var opacity: Double
    var rotation: Double
}

