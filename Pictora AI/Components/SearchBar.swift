import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(isFocused ? .white : .gray)
            
            TextField("Search presets...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.fkDisplay(.regular, size: 16))
                .foregroundColor(.white)
                .textCase(.lowercase)
                .autocorrectionDisabled()
                .autocapitalization(.none)
                .focused($isFocused)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.gray)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    .white.opacity(isFocused ? 0.3 : 0.1),
                                    .clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.5
                        )
                )
        )
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}


