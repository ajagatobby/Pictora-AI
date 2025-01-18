import SwiftUI
import CoreHaptics

enum HapticType {
    case success
    case warning
    case error
    case light
    case medium
    case heavy
    case soft
    case rigid
    case selection
}

class HapticManager {
    static let shared = HapticManager()
    
    private var engine: CHHapticEngine?
    
    private init() {
        setupHapticEngine()
    }
    
    private func setupHapticEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
            
            // Restart the engine if necessary
            engine?.resetHandler = { [weak self] in
                guard let self = self else { return }
                try? self.engine?.start()
            }
            
            // Handle engine stopping
            engine?.stoppedHandler = { reason in
                print("Haptic engine stopped: \(reason)")
            }
            
        } catch {
            print("Failed to create haptic engine: \(error.localizedDescription)")
        }
    }
    
    func trigger(_ type: HapticType) {
        switch type {
        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
            
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            
        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
        case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            
        case .soft:
            let generator = UIImpactFeedbackGenerator(style: .soft)
            generator.impactOccurred()
            
        case .rigid:
            let generator = UIImpactFeedbackGenerator(style: .rigid)
            generator.impactOccurred()
            
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
    }
    
    // Advanced custom haptic pattern
    func playCustomHaptic(intensity: Float, sharpness: Float, duration: Double = 0.5) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics,
              let engine = engine else { return }
        
        let intensityParameter = CHHapticEventParameter(parameterID: .hapticIntensity,
                                                      value: intensity)
        let sharpnessParameter = CHHapticEventParameter(parameterID: .hapticSharpness,
                                                      value: sharpness)
        
        let event = CHHapticEvent(eventType: .hapticContinuous,
                                parameters: [intensityParameter, sharpnessParameter],
                                relativeTime: 0,
                                duration: duration)
        
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            print("Failed to play custom haptic: \(error.localizedDescription)")
        }
    }
}

// SwiftUI View Modifier
struct HapticFeedback: ViewModifier {
    let type: HapticType
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(TapGesture().onEnded { _ in
                HapticManager.shared.trigger(type)
            })
    }
}

// Custom haptic modifier
struct CustomHapticFeedback: ViewModifier {
    let intensity: Float
    let sharpness: Float
    let duration: Double
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(TapGesture().onEnded { _ in
                HapticManager.shared.playCustomHaptic(
                    intensity: intensity,
                    sharpness: sharpness,
                    duration: duration
                )
            })
    }
}

// View extension for easier usage
extension View {
    func hapticFeedback(_ type: HapticType) -> some View {
        modifier(HapticFeedback(type: type))
    }
    
    func customHapticFeedback(intensity: Float = 1.0,
                            sharpness: Float = 1.0,
                            duration: Double = 0.5) -> some View {
        modifier(CustomHapticFeedback(intensity: intensity,
                                    sharpness: sharpness,
                                    duration: duration))
    }
}
