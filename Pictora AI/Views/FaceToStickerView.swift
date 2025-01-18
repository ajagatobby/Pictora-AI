import SwiftUI
import PhotosUI

enum StickerTab {
    case create
    case myStickers
    
    var index: Int {
        switch self {
        case .create: return 0
        case .myStickers: return 1
        }
    }
}

struct FaceToStickerView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedTab: StickerTab = .create
    @State private var previousTab: StickerTab = .create
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @Namespace private var animation
    
    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground2()
                MainContent()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CustomBackButton()
                }
                
                ToolbarItem(placement: .principal) {
                    Typography(label: "Photo To Sticker", variants: .logo, color: .white)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Main Content
    private func MainContent() -> some View {
        VStack(spacing: 0) {
            TabContent()
            BottomBar()
        }
    }
    
    // MARK: - Tab Content
    private func TabContent() -> some View {
        ZStack {
            createContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(x: selectedTab == .create ? 0 : -UIScreen.main.bounds.width)
                .opacity(selectedTab == .create ? 1 : 0)
            
            myStickerContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(x: selectedTab == .myStickers ? 0 : UIScreen.main.bounds.width)
                .opacity(selectedTab == .myStickers ? 1 : 0)
        }
        .animation(.spring(response: 0.5, dampingFraction: 1), value: selectedTab)
    }
    
    // MARK: - Bottom Bar
    private func BottomBar() -> some View {
        VStack(spacing: 0) {
            if selectedTab == .create {
                CreateButton()
            }
            
            TabBar()
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
    
    private func CreateButton() -> some View {
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
    
    private func TabBar() -> some View {
        HStack(spacing: 0) {
            ForEach([StickerTab.create, .myStickers], id: \.index) { tab in
                TabButton2(
                    isSelected: selectedTab == tab,
                    icon: tab == .create ? "square.grid.2x2" : "person.2",
                    title: tab == .create ? "Create" : "My Stickers"
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
    
    // MARK: - Create Content
    private var createContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                EnhancedPhotoUpload(
                    selectedItem: $selectedItem,
                    selectedImage: $selectedImage
                )
                .onChange(of: selectedItem) { _ in
                    Task {
                        if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                selectedImage = uiImage
                                return
                            }
                        }
                        print("Failed to load image")
                    }
                }
            }
            .padding()
        }
    }
    
    private var myStickerContent: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Typography(
                    label: "Your stickers will appear here",
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
    FaceToStickerView()
}
