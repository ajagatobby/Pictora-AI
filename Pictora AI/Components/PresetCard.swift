import SwiftUI

struct PresetCard: View {
    @State private var colorIntensity: CGFloat = 0.2
    @State private var currentColorIndex: Int = 0
    @State private var isAnimating: Bool = false
    var selected: Bool
    var label: String
    var imageName: String
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
            // Image Container
            NetworkColorAdjustableImage(
                imageURL: imageName,
                adjustmentColor: colors[currentColorIndex],
                colorIntensity: $colorIntensity
            )
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

// Helper extension for hex colors
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
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        PresetCard(
            selected: true,
            label: "Cinematic",
            imageName: "https://example.com/image.jpg",
            perform: {}
        )
        .padding()
    }
}
