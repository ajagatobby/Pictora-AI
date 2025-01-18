import SwiftUI

struct SignaturePresetCard: View {
    @State private var colorIntensity: CGFloat = 0.2
    @State private var currentColorIndex: Int = 0
    @State private var isAnimating: Bool = false
    var selected: Bool
    var label: String
    var imageName: String
    var isPremium: Bool
    var perform: () -> Void
    
    // Enhanced color palette with more AI-style gradients
    private let colors: [Color] = [
        .purple,
        .blue,
        .indigo,
        Color(hex: "FF00FF").opacity(0.8) // Magenta
    ]
    
    private let timer = Timer.publish(every: 2.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 8) {
            // Image Container with lock overlay
            ZStack {
                ColorAdjustableImage(
                    imageName: imageName,
                    adjustmentColor: colors[currentColorIndex],
                    colorIntensity: $colorIntensity
                )
                
                if isPremium {
                    // Lock Icon with backdrop
                    ZStack {
                        Circle()
                            .fill(.black.opacity(0.5))
                            .frame(width: 40, height: 40)
                            .blur(radius: 2)
                        
                        Image(systemName: "lock.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
            }
            .overlay {
                // Selection border with gradient
                if selected {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    colors[currentColorIndex].opacity(0.8),
                                    colors[(currentColorIndex + 1) % colors.count].opacity(0.6)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                        .animation(.easeInOut(duration: 0.3), value: selected)
                }
            }
            .overlay {
                // Glow effect
                if selected {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                colors: [
                                    colors[currentColorIndex].opacity(0.3),
                                    colors[(currentColorIndex + 1) % colors.count].opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .blur(radius: isAnimating ? 8 : 4)
                        .animation(
                            .easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                }
            }
            // Card background with subtle gradient
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [.white.opacity(0.2), .clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 0.5
                            )
                    )
            )
            
            // Label with gradient text when selected
            Typography(
                label: label,
                variants: .body2,
                color: selected ? .clear : .gray
            )
            .overlay {
                if selected {
                    LinearGradient(
                        colors: [
                            colors[currentColorIndex],
                            colors[(currentColorIndex + 1) % colors.count]
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .mask(
                        Typography(
                            label: label,
                            variants: .body2,
                            color: .white
                        )
                    )
                }
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(
                            LinearGradient(
                                colors: [.white.opacity(0.1), .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.5
                        )
                )
        )
        .onTapGesture {
            perform()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isAnimating.toggle()
            }
            HapticManager.shared.trigger(.light)
        }
        .onReceive(timer) { _ in
            if selected {
                withAnimation(.easeInOut(duration: 1.0)) {
                    currentColorIndex = (currentColorIndex + 1) % colors.count
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        HStack(spacing: 16) {
            // Non-premium card
            SignaturePresetCard(
                selected: false,
                label: "Business",
                imageName: "calligraphic",
                isPremium: false,
                perform: {}
            )
            
            // Premium card
            SignaturePresetCard(
                selected: true,
                label: "Elegant",
                imageName: "signature2",
                isPremium: true,
                perform: {}
            )
        }
        .padding()
    }
}
