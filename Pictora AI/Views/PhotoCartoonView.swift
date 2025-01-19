import SwiftUI
import PhotosUI

enum CartoonTab {
    case create
    case myCartoons
    
    var index: Int {
        switch self {
        case .create: return 0
        case .myCartoons: return 1
        }
    }
}

struct PhotoToCartoonView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedTab: CartoonTab = .create
    @State private var previousTab: CartoonTab = .create
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
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
                        
                        myCartoonsContent
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .offset(x: selectedTab == .myCartoons ? 0 : UIScreen.main.bounds.width)
                            .opacity(selectedTab == .myCartoons ? 1 : 0)
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
                        
                        // Tab Bar
                        HStack(spacing: 0) {
                            ForEach([CartoonTab.create, .myCartoons], id: \.index) { tab in
                                TabButton2(
                                    isSelected: selectedTab == tab,
                                    icon: tab == .create ? "square.grid.2x2" : "person.2",
                                    title: tab == .create ? "Create" : "My Cartoons"
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
                    Typography(label: "Photo to Cartoon", variants: .logo, color: .white)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Create Content
    private var createContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                EnhancedPhotoUpload(
                    selectedItem: $selectedItem,
                    selectedImage: $selectedImage
                )
                
                // Add the onChange handler here if you want
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
            .padding(.top, 40)
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
    
    private var myCartoonsContent: some View {
        ScrollView(showsIndicators: false) {
            if myArts.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "photo.stack.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.white.opacity(0.3))
                        .padding(.bottom, 8)
                    
                    VStack(spacing: 8) {
                        Typography(
                            label: "No Creations Yet",
                            variants: .body2,
                            color: .white.opacity(0.9)
                        )
                        
                        Typography(
                            label: "Your AI-generated art will appear here",
                            variants: .body1,
                            color: .white.opacity(0.6)
                        )
                    }
                    
                    Button(action: {}) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .medium))
                            Text("Create New")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(Color.blue)
                        )
                    }
                    .padding(.top, 16)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal)
                .padding(.vertical, 40)
            } else {
                LazyVStack(spacing: 0) {
                    ArtCollectionGrid(arts: myArts)
                        .padding(.vertical, 50)
                }
                .padding(.horizontal)
            }
        }
        .background(.ultraThinMaterial)
    }
}

#Preview {
    PhotoToCartoonView()
}
