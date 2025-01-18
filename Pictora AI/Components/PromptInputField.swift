import SwiftUI

// Background component
struct PromptBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.black.opacity(0.2))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
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

// Info row component
struct PromptInfoRow: View {
    let textCount: Int
    
    var body: some View {
        HStack {
            HStack(spacing: 6) {
                Image(systemName: "info.circle")
                    .imageScale(.small)
                Text("Be descriptive for better results")
                    .font(.fkDisplay(.regular, size: 12))
            }
            .foregroundColor(.gray)
            
            Spacer()
            
            Text("\(textCount)/500")
                .font(.fkDisplay(.regular, size: 12))
                .foregroundColor(textCount > 500 ? .red : .gray)
        }
    }
}

struct PromptInputField: View {
    @Binding var text: String
    var placeholder: String
    var onSubmit: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // Input area
            HStack(alignment: .top, spacing: 5) {
                Image(systemName: "sparkles")
                    .foregroundStyle(.purple)
                    .frame(width: 24, height: 24)
                
                ZStack(alignment: .topLeading) {
                    if text.isEmpty {
                        Text(placeholder)
                            .font(.fkDisplay(.regular, size: 16))
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                            .padding(.leading, 4)
                    }
                    
                    TextEditor(text: $text)
                        .font(.fkDisplay(.regular, size: 16))
                        .textCase(.lowercase)
                        .autocorrectionDisabled()
                        .frame(minHeight: 80)
                        .scrollContentBackground(.hidden)
                        .foregroundColor(.white)
                }
                
                if !text.isEmpty {
                    Button(action: { text = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .imageScale(.medium)
                    }
                }
            }
            
            // Info row
            PromptInfoRow(textCount: text.count)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(PromptBackground())
        .animation(.easeInOut(duration: 0.2), value: text)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        PromptInputField(
            text: .constant(""),
            placeholder: "A cute baby from krypton",
            onSubmit: {}
        )
        .padding()
    }
}
