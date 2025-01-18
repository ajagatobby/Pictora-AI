import SwiftUI

// MARK: - AI Tool Card Component
struct AIToolCard: View {
    let imageName: String
    let title: String
    let description: String
    let accentColor: Color
    var onTap: () -> Void
    
    @State private var isPressed: Bool = false
    
    var body: some View {
        Button(action: {
            HapticManager.shared.trigger(.medium)
            withAnimation(.spring(duration: 0.1)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(duration: 0.1)) {
                    isPressed = false
                }
                onTap()
            }
        }) {
            HStack(spacing: 20) {
                ColorAdjustableImage(
                    imageName: imageName,
                    height: 80,
                    width: 80,
                    adjustmentColor: accentColor,
                    colorIntensity: .constant(imageName == "remove-bg" ? 0.8 : 0.4)
                )
                
                
                VStack(alignment: .leading, spacing: 8) {
                    Typography(
                        label: title,
                        variants: .body1,
                        color: .white
                    )
                    
                    Typography(
                        label: description,
                        variants: .body2,
                        color: .white.opacity(0.6)
                    )
                }
                Spacer()
            }
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(16)
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .frame(width: .infinity)
        .buttonStyle(PlainButtonStyle())
    }
}


