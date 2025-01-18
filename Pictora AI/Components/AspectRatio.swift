import SwiftUI

struct AspectRatioButton: View {
    let ratio: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(ratio)
                .font(.fkDisplay(.regular, size: 14))
                .foregroundColor(isSelected ? .white : .gray)
                .frame(height: 36)
                .padding(.horizontal, 16)
                .background(
                    Group {
                        if isSelected {
                            LinearGradient(
                                colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        } else {
                            Color.black.opacity(0.3)
                        }
                    }
                )
                .cornerRadius(100)
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .strokeBorder(
                            LinearGradient(
                                colors: [.white.opacity(0.2), .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.5
                        )
                )
        }
    }
}

