import SwiftUI
import Photos
import UIKit

struct ShimmerEffect: View {
    @State private var phase: CGFloat = 0
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color.clear, location: 0),
                .init(color: Color.white.opacity(0.2), location: 0.3),
                .init(color: Color.white.opacity(0.4), location: 0.5),
                .init(color: Color.white.opacity(0.2), location: 0.7),
                .init(color: Color.clear, location: 1),
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
        .mask(Rectangle())
        .offset(x: -200 + (phase * 500))
        .animation(
            Animation.linear(duration: 1.5)
                .repeatForever(autoreverses: false),
            value: phase
        )
        .onAppear {
            phase = 1
        }
    }
}

extension UIImage {
    func saveToPhotos(completion: @escaping (Bool, Error?) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                completion(false, nil)
                return
            }
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: self)
            }, completionHandler: completion)
        }
    }
}

struct GlassMorphicBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color.black.opacity(0.7),
                Color.black.opacity(0.4)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .background(.ultraThinMaterial)
    }
}

struct ActionButtonStyle: View {
    let icon: String
    let title: String
    let isHighlighted: Bool
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3)) {
                    isPressed = false
                }
                action()
            }
        }) {
            VStack(spacing: 6) {
                ZStack {
                    if isHighlighted {
                        Circle()
                            .fill(Color.blue)
                            .blur(radius: isPressed ? 10 : 5)
                            .opacity(0.5)
                    }
                    
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: isHighlighted ?
                                [Color.blue, Color.blue.opacity(0.8)] :
                                    [Color.white.opacity(0.15), Color.white.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }
                .frame(width: 52, height: 52)
                .scaleEffect(isPressed ? 0.9 : 1)
                
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
    }
}

struct ArtDetailView: View {
    let art: Art
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: NetworkImageViewModel
    @State private var showingSaveAlert = false
    @State private var saveAlertTitle = ""
    @State private var saveAlertMessage = ""
    
    init(art: Art) {
        self.art = art
        _viewModel = StateObject(wrappedValue: NetworkImageViewModel(url: art.imageLink))
    }
    
    func saveImage() {
        guard let image = viewModel.image else {
            showSaveAlert(success: false)
            return
        }
        
        // Convert to JPEG data with high quality
        guard let imageData = image.jpegData(compressionQuality: 1),
              let convertedImage = UIImage(data: imageData) else {
            showSaveAlert(success: false)
            return
        }
        
        convertedImage.saveToPhotos { success, error in
            DispatchQueue.main.async {
                showSaveAlert(success: success, error: error)
            }
        }
    }
    
    func shareImage() {
        guard let uiImage = viewModel.image else { return }
        let itemsToShare: [Any] = [
            uiImage,
            "\(shareText)\n\(appLink)"
        ]
        
        let activityVC = UIActivityViewController(
            activityItems: itemsToShare,
            applicationActivities: nil
        )
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        // Find the currently presented view controller
        var currentController = rootViewController
        while let presented = currentController.presentedViewController {
            currentController = presented
        }
        
        // For iPad
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = currentController.view
            popover.sourceRect = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        currentController.present(activityVC, animated: true)
    }
    
    func showSaveAlert(success: Bool, error: Error? = nil) {
        saveAlertTitle = success ? "Success" : "Error"
        saveAlertMessage = success ? "Image saved to photos" : (error?.localizedDescription ?? "Failed to save image")
        showingSaveAlert = true
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    .black.opacity(0.4),
                    .clear,
                    .black.opacity(0.3)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                GeometryReader { geometry in
                    CachedNetworkImage(url: art.imageLink) {
                        ZStack {
                            Color.black
                            ShimmerEffect()
                        }
                    }
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                }
                
                VStack(spacing: 20) {
                    HStack(spacing: 24) {
                        ActionButtonStyle(
                            icon: "wand.and.stars",
                            title: "Remix",
                            isHighlighted: false
                        ) {}
                        
                        ActionButtonStyle(
                            icon: "square.and.arrow.down",
                            title: "Save",
                            isHighlighted: false
                        ) {
                            saveImage()
                        }
                        
                        ActionButtonStyle(
                            icon: "paperplane.fill",
                            title: "Share",
                            isHighlighted: true
                        ) {
                            shareImage()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
            }
        }
        .background(Color.black)
        .preferredColorScheme(.dark)
        .alert(saveAlertTitle, isPresented: $showingSaveAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(saveAlertMessage)
        }
    }
}

struct ArtCollectionGrid: View {
    let arts: [Art]
    private let spacing: CGFloat = 10
    
    private var columns: [GridItem] {
        [
            GridItem(.flexible(), spacing: spacing),
            GridItem(.flexible(), spacing: spacing)
        ]
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(arts, id: \.id) { art in
                    ArtGridItem(art: art)
                }
            }
        }
    }
}

struct ArtGridItem: View {
    let art: Art
    @State private var isExpanded = false
    @State private var imageLoaded = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                isExpanded.toggle()
            }
        }) {
            GeometryReader { geometry in
                CachedNetworkImage(url: art.imageLink) {
                    ZStack {
                        Color.gray.opacity(0.15)
                        ShimmerEffect()
                    }
                }
                .cornerRadius(15)
                .onAppear {
                    withAnimation(.easeIn(duration: 0.3)) {
                        imageLoaded = true
                    }
                }
                .onDisappear {
                    imageLoaded = false
                }
                .scaledToFill()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .cornerRadius(15)
            }
            .aspectRatio(0.5, contentMode: .fill)
            .opacity(imageLoaded ? 1 : 0.7)
        }
        .buttonStyle(ScaleButtonStyle())
        .sheet(isPresented: $isExpanded) {
            ArtDetailView(art: art)
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}
