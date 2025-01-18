import SwiftUI

// Define Particle struct first
struct Particle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var speed: CGFloat
    var scale: CGFloat
}

struct ParticleView: View {
    @ObservedObject var system: ParticleSystem
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(system.particles) { particle in
                Circle()
                    .fill(.white)
                    .frame(width: 4, height: 4)
                    .scaleEffect(particle.scale)
                    .blur(radius: 1)
                    .shadow(color: .white.opacity(0.5), radius: 2)
                    .blendMode(.screen)
                    .position(
                        x: particle.x * geometry.size.width,
                        y: particle.y * geometry.size.height
                    )
            }
        }
    }
}

class ParticleSystem: ObservableObject {
    @Published var particles: [Particle]
    private var displayLink: Timer?
    
    init(particles count: Int) {
        self.particles = (0..<count).map { _ in
            Particle(
                x: CGFloat.random(in: 0...1),
                y: CGFloat.random(in: 0...1),
                speed: CGFloat.random(in: 0.2...0.8),
                scale: CGFloat.random(in: 0.3...1.2)
            )
        }
    }
    
    func start() {
        displayLink?.invalidate()
        displayLink = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { [weak self] _ in
            self?.updateParticles()
        }
    }
    
    private func updateParticles() {
        for i in 0..<particles.count {
            var particle = particles[i]
            particle.y -= particle.speed / 50
            particle.x += sin(particle.y * 2) * 0.02
            
            if particle.y < 0 {
                particle.y = 1
                particle.x = CGFloat.random(in: 0...1)
                particle.speed = CGFloat.random(in: 0.2...0.8)
                particle.scale = CGFloat.random(in: 0.3...1.2)
            }
            
            particles[i] = particle
        }
        objectWillChange.send()
    }
    
    deinit {
        displayLink?.invalidate()
    }
}
