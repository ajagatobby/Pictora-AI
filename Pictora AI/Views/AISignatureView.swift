import SwiftUI

enum SignatureTab {
    case create
    case mySignatures
    
    var index: Int {
        switch self {
        case .create: return 0
        case .mySignatures: return 1
        }
    }
}

struct AISignatureView: View {
    @State private var text: String = ""
    @State private var selectedTab: SignatureTab = .create
    @State private var previousTab: SignatureTab = .create
    @Namespace private var animation
    
    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground2()
                
                VStack(spacing: 0) {
                    // Content with horizontal slide animation
                    ZStack {
                        createContent
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .offset(x: selectedTab == .create ? 0 : -UIScreen.main.bounds.width)
                            .opacity(selectedTab == .create ? 1 : 0)
                        
                        mySignaturesContent
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .offset(x: selectedTab == .mySignatures ? 0 : UIScreen.main.bounds.width)
                            .opacity(selectedTab == .mySignatures ? 1 : 0)
                    }
                    .animation(.spring(response: 0.5, dampingFraction: 1), value: selectedTab)
                    
                    VStack(spacing: 0) {
                        if selectedTab == .create {
                            CustomButton(
                                label: "Create",
                                background: .solid(.white),
                                textColor: .black,
                                icon: "arrow.right",
                                position: .trailing
                            )
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                        
                        // Enhanced Tab Bar
                        // Update the overlay in the tab bar HStack to make the indicator shorter
                        HStack(spacing: 0) {
                            ForEach([SignatureTab.create, .mySignatures], id: \.index) { tab in
                                TabButton2(
                                    isSelected: selectedTab == tab,
                                    icon: tab == .create ? "square.grid.2x2" : "person.2",
                                    title: tab == .create ? "Create" : "My Signatures"
                                ) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                        previousTab = selectedTab
                                        selectedTab = tab
                                    }
                                }
                            }
                        }
                        .padding(.top, 16)
                        .padding(.bottom, 32)
                    }
                    .background(
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.2)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: selectedTab)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CustomBackButton()
                }
                
                ToolbarItem(placement: .principal) {
                    Typography(label: "AI Signature", variants: .logo, color: .white)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Create Content
    private var createContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                VStack(spacing: 24) {
                    PromptInputField(
                        text: $text,
                        placeholder: "Specify your signature by writing it as a text.",
                        onSubmit: {}
                    )
                    .frame(height: 180)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Typography(
                            label: "Signature Presets",
                            variants: .body1,
                            color: .white
                        )
                        
                        SignaturePresetGrid()
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top)
        }
    }
    
    private var mySignaturesContent: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Typography(
                    label: "My Signatures will appear here",
                    variants: .body1,
                    color: .white.opacity(0.6)
                )
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }
}

#Preview {
    AISignatureView()
}

struct TabButton2: View {
    let isSelected: Bool
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Typography(
                    label: title,
                    variants: .body2,
                    color: isSelected ? Color(hex: "6366F1") : .white.opacity(0.6)
                )
            }
            .frame(maxWidth: .infinity)
        }
        .foregroundColor(isSelected ? Color(hex: "6366F1") : .white.opacity(0.6))
    }
}

#Preview {
    AISignatureView()
}


struct CustomBackButton: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "arrow.left")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
        }
    }
}
