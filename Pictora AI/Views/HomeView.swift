import SwiftUI

struct HomeView: View {
    @State private var text: String = ""
    @State private var adjusableColor: CGFloat = 0.0
    @State private var selectedIds: [String] = []
    @State private var keyboardHeight: CGFloat = 0
    @FocusState private var isFocused: Bool
    @FocusState private var negativePromptFocused: Bool
    @State private var submittedRequest: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                GradientBackground()
                
                VStack(spacing: 0) {
                    ScrollViewReader { scrollProxy in
                        ScrollView {
                            VStack(spacing: 24) {
                                VStack(alignment: .leading, spacing: 16) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Typography(label: "Generate Image", variants: .display2, color: .white)
                                        Typography(label: "Enter your prompt", variants: .body2, color: .gray)
                                    }
                                    .padding(.top, 25)
                                    
                                    PromptInputField(
                                        text: $text,
                                        placeholder: "A cute baby from krypton",
                                        onSubmit: {}
                                    )
                                    .frame(height: 150)
                                    .focused($isFocused)
                                    .background(
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
                                    )
                                    
                                    VStack(alignment: .leading) {
                                        PresetGridView()
                                    }
                                    .padding(.vertical, 8)
                                    
                                    AdvancedSettings(negativePromptFocused: _negativePromptFocused)
                                        .id("advancedSettings")
                                }
                                .padding(.horizontal)
                            }
                            .padding(.top, 20)
                            .padding(.bottom, 120) // Increased bottom padding to account for tab bar
                        }
                        .onChange(of: negativePromptFocused) { isFocused in
                            if isFocused {
                                withAnimation {
                                    scrollProxy.scrollTo("advancedSettings", anchor: .center)
                                }
                            }
                        }
                        .simultaneousGesture(
                            TapGesture().onEnded { _ in
                                isFocused = false
                                negativePromptFocused = false
                            }
                        )
                        .scrollDismissesKeyboard(.immediately)
                    }
                    
                    // Fixed Generate Button at bottom
                    VStack {
                        HStack {
                            Spacer()
                            CustomButton(
                                label: "Generate",
                                background: .solid(.white),
                                textColor: .black,
                                icon: "sparkles",
                                isEnabled: !text.isEmpty,
                                onClick: {
                                    submittedRequest = true
                                }
                            )
                            Spacer()
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal)
                    }
                    .padding(.bottom, keyboardHeight > 0 ? keyboardHeight - 30 : 70) // Added extra padding for tab bar
                    .background(.clear)
                }
            }
        }
        .fullScreenCover(isPresented: $submittedRequest) {
            AIGenerationLoadingView()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
                keyboardHeight = keyboardFrame.height
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                keyboardHeight = 0
            }
        }
    }
}

#Preview {
    HomeView()
}
