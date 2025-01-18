import SwiftUI

struct GradientBackground: View {
    @State private var gradientPosition = UnitPoint(x: 1, y: 1)
    
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    @State private var elapsedTime: Double = 0
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Bottom right gradient with animation
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.pink.opacity(0.1),
                    .clear
                ]),
                center: gradientPosition,
                startRadius: 10,
                endRadius: 200
            )
            .onReceive(timer) { _ in
                elapsedTime += 0.016
                let t = elapsedTime
                
                // Figure-8 pattern
                let x = 0.7 * sin(2 * t) / 2 + 0.5
                let y = 0.7 * sin(t) / 2 + 0.5
                
                withAnimation(.linear(duration: 0.016)) {
                    gradientPosition = UnitPoint(x: x, y: y)
                }
            }
            
            // Top left gradient
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.2),
                    .clear
                ]),
                center: .topLeading,
                startRadius: 0,
                endRadius: 400
            )
            
            // Ambient blur effect
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
        }
    }
}


struct GradientBackground2: View {
    @State private var gradientPosition = UnitPoint(x: 1, y: 1)
    
    let timer = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()
    @State private var elapsedTime: Double = 0
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Bottom right gradient with animation
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.pink.opacity(0.2),
                    .clear
                ]),
                center: gradientPosition,
                startRadius: 10,
                endRadius: 200
            )
            .onReceive(timer) { _ in
                elapsedTime += 0.016
                let t = elapsedTime
                
                // Figure-8 pattern
                let x = 0.7 * sin(2 * t) / 2 + 0.5
                let y = 0.7 * sin(t) / 2 + 0.5
                
                withAnimation(.linear(duration: 0.016)) {
                    gradientPosition = UnitPoint(x: x, y: y)
                }
            }
            
            // Top left gradient
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.2),
                    .clear
                ]),
                center: .topLeading,
                startRadius: 0,
                endRadius: 400
            )
            
            // Ambient blur effect
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
        }
    }
}


struct GradientBackground3: View {
    @State private var gradientPosition = UnitPoint(x: 1, y: 1)
    
    let timer = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()
    @State private var elapsedTime: Double = 0
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Bottom right gradient with animation
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.pink.opacity(0.2),
                    .clear
                ]),
                center: gradientPosition,
                startRadius: 10,
                endRadius: 200
            )
            .onReceive(timer) { _ in
                elapsedTime += 0.016
                let t = elapsedTime
                
                // Figure-8 pattern
                let x = 0.7 * sin(2 * t) / 2 + 0.5
                let y = 0.7 * sin(t) / 2 + 0.5
                
                withAnimation(.linear(duration: 0.016)) {
                    gradientPosition = UnitPoint(x: x, y: y)
                }
            }
            
            // Top left gradient
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.2),
                    .clear
                ]),
                center: .topLeading,
                startRadius: 0,
                endRadius: 400
            )
            
            // Ambient blur effect
            Rectangle()
                .fill(.black.gradient)
                .ignoresSafeArea()
        }
    }
}
