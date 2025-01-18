import SwiftUI

struct SearchInput: View {
    @Binding var text: String
    var placeholder: String = "Search..."
    var onSubmit: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 8) {
            // Search Icon
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(.systemGray3))
                .frame(width: 20, height: 20)
            
            // Text Field
            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.fkDisplay(.regular, size: 16))
                .textCase(.lowercase)
                .autocorrectionDisabled()
                .autocapitalization(.none)
                .onSubmit {
                    onSubmit?()
                }
            
            // Clear button when text is not empty
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(.systemGray3))
                }
                .transition(.opacity)
                .animation(.easeInOut, value: text)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 14)
        .background(Color(.systemGray6))
        .cornerRadius(100)
    }
}

#Preview {
    VStack(spacing: 20) {
        // Light mode example
        SearchInput(text: .constant(""))
            .padding()
        
        // Dark mode example with text
        SearchInput(text: .constant("Hello"))
            .padding()
            .preferredColorScheme(.dark)
        
        // With custom placeholder
        SearchInput(
            text: .constant(""),
            placeholder: "Search products...",
            onSubmit: { print("Search submitted") }
        )
        .padding()
    }
}
