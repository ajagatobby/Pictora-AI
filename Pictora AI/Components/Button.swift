import SwiftUI

enum Position: String {
    case leading
    case trailing
}

enum AppleLogoType: String {
    case light
    case dark
}

// New enum to handle different background types
enum ButtonBackground {
    case solid(Color)
    case gradient(LinearGradient)
}

struct CustomButton: View {
    var label: String
    var width: CGFloat?
    var height: CGFloat?
    var showAppleIcon: Bool = false
    var appleLogoType: AppleLogoType = .dark
    var background: ButtonBackground
    var textColor: Color?
    var icon: String?
    var position: Position = .leading
    var iconSize: CGFloat?
    var spacing: CGFloat?
    var isEnabled: Bool = true
    var onClick: (() -> Void)?
    
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
                onClick?()
            }
        }) {
            HStack(spacing: spacing) {
                if showAppleIcon {
                    Image(appleLogoType == .dark ? "apple-black" : "apple")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(textColor ?? .white)
                }
                
                if position == .leading {
                    if !showAppleIcon && icon != nil {
                        Image(systemName: icon ?? "")
                            .frame(width: iconSize, height: iconSize)
                            .foregroundColor(textColor ?? .white)
                    }
                }
                
                Text(label)
                    .font(.fkDisplay(.regularAlt, size: 16))
                    .foregroundColor(textColor ?? .white)
                
                if position == .trailing {
                    if !showAppleIcon && icon != nil {
                        Image(systemName: icon ?? "")
                            .frame(width: iconSize, height: iconSize)
                            .foregroundColor(textColor ?? .white)
                    }
                }
            }
            .padding(.horizontal)
            .frame(width: width ?? UIScreen.main.bounds.size.width - 80, height: height ?? 55)
            .background(
                Group {
                    switch background {
                    case .solid(let color):
                        color.opacity(isEnabled ? 1 : 0.85)
                    case .gradient(let gradient):
                        gradient.opacity(isEnabled ? 1 : 0.85)
                    }
                }
            )
            .cornerRadius(100)
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled)
    }
}

// Convenience initializer extensions
extension CustomButton {
    init(
        label: String,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        showAppleIcon: Bool = false,
        appleLogoType: AppleLogoType = .dark,
        solidColor: Color, // For backward compatibility
        textColor: Color? = nil,
        icon: String? = nil,
        position: Position = .leading,
        iconSize: CGFloat? = nil,
        spacing: CGFloat? = nil,
        isEnabled: Bool = true,
        onClick: (() -> Void)? = nil
    ) {
        self.label = label
        self.width = width
        self.height = height
        self.showAppleIcon = showAppleIcon
        self.appleLogoType = appleLogoType
        self.background = .solid(solidColor)
        self.textColor = textColor
        self.icon = icon
        self.position = position
        self.iconSize = iconSize
        self.spacing = spacing
        self.isEnabled = isEnabled
        self.onClick = onClick
    }
}

#Preview {
    VStack(spacing: 20) {
        // Solid color button
        CustomButton(
            label: "Solid Color",
            solidColor: .blue,
            textColor: .white,
            icon: "arrow.right",
            position: .trailing,
            spacing: 10,
            onClick: { print("Tapped!") }
        )
        
        // Gradient button
        CustomButton(
            label: "Gradient",
            background: .gradient(
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            ),
            textColor: .white,
            icon: "sparkles",
            position: .leading,
            spacing: 10,
            onClick: { print("Tapped!") }
        )
    }
    .padding()
}
