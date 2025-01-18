import SwiftUI
import PhotosUI

struct EnhancedPhotoUpload: View {
    @Binding var selectedItem: PhotosPickerItem?
    @Binding var selectedImage: UIImage?
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State private var isHovering = false
    @State private var isAnimating = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    @State private var showingFullscreen = false
    @State private var showingFilterOptions = false
    @State private var currentFilter: ImageFilter = .none
    @State private var brightness: Double = 0
    @State private var contrast: Double = 1
    @State private var saturation: Double = 1
    @State private var rotationAngle: Angle = .zero
    @State private var draggedOffset: CGSize = .zero
    
    // Parallax effect
    @State private var parallaxOffset: CGSize = .zero
    
    // Animation properties
    @State private var scale: CGFloat = 1
    @Namespace private var animation
    
    enum ImageFilter: String, CaseIterable {
        case none = "Original"
        case mono = "Mono"
        case sepia = "Sepia"
        case vibrant = "Vibrant"
    }
    
    var filteredImage: some View {
        Group {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFill()
                    .saturation(saturation)
                    .brightness(brightness)
                    .contrast(contrast)
                    .colorMultiply(filterColor)
                    .rotationEffect(rotationAngle)
            }
        }
    }
    
    var filterColor: Color {
        switch currentFilter {
        case .none:
            return .white
        case .mono:
            return .gray
        case .sepia:
            return Color(red: 1.1, green: 0.9, blue: 0.7)
        case .vibrant:
            return Color(red: 1.1, green: 1.1, blue: 1.0)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Main container
            ZStack {
                // Animated background
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hex: "1a1a1a"),
                                Color(hex: "2a2a2a")
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(
                                LinearGradient(
                                    colors: isHovering ?
                                        [Color.purple.opacity(0.6), Color.blue.opacity(0.6)] :
                                        [Color.white.opacity(0.3), Color.white.opacity(0.1), Color.clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: isHovering ? 2 : 1
                            )
                            .animation(.easeInOut(duration: 0.3), value: isHovering)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                
                // Content
                VStack(spacing: 16) {
                    // Upload area with strict image filtering
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Group {
                            if let _ = selectedImage {
                                // Premium selected image view
                                ZStack {
                                    // Background blur effect
                                    filteredImage
                                        .blur(radius: 20)
                                        .opacity(0.3)
                                        .frame(height: 160)
                                        .frame(maxWidth: .infinity)
                                        .scaleEffect(1.2)
                                    
                                    // Main image with glass morphism effect
                                    ZStack {
                                        // Glassmorphism background
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(.ultraThinMaterial)
                                            .opacity(0.8)
                                        
                                        // Image with effects
                                        filteredImage
                                            .frame(height: 140)
                                            .frame(maxWidth: .infinity)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(
                                                        .linearGradient(
                                                            colors: [
                                                                .white.opacity(0.5),
                                                                .clear,
                                                                .white.opacity(0.2)
                                                            ],
                                                            startPoint: .topLeading,
                                                            endPoint: .bottomTrailing
                                                        ),
                                                        lineWidth: 1
                                                    )
                                            )
                                    }
                                    .scaleEffect(imageScale)
                                    .offset(imageOffset)
                                    .offset(parallaxOffset)
                                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                                    .gesture(
                                        MagnificationGesture()
                                            .simultaneously(with: DragGesture())
                                            .onChanged { value in
                                                if let magnification = value.first {
                                                    imageScale = magnification.magnitude
                                                }
                                                if let drag = value.second {
                                                    imageOffset = drag.translation
                                                    // Enhanced parallax effect
                                                    let parallaxAmount: CGFloat = 8
                                                    parallaxOffset = CGSize(
                                                        width: drag.translation.width / parallaxAmount,
                                                        height: drag.translation.height / parallaxAmount
                                                    )
                                                }
                                            }
                                            .onEnded { _ in
                                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.5)) {
                                                    imageScale = 1
                                                    imageOffset = .zero
                                                    parallaxOffset = .zero
                                                }
                                            }
                                        )
                                        .overlay(
                                            // Enhanced overlay
                                            ZStack {
                                                Color.black.opacity(isHovering ? 0.4 : 0)
                                                // Premium floating controls
                                                HStack(spacing: 16) {
                                                    ForEach([
                                                        ("arrow.up.left.and.arrow.down.right", { showingFullscreen.toggle() }),
                                                        ("slider.horizontal.3", { showingFilterOptions.toggle() }),
                                                        ("rotate.right", {
                                                            withAnimation(.spring()) {
                                                                rotationAngle += .degrees(90)
                                                            }
                                                        }),
                                                        ("arrow.triangle.2.circlepath.camera", { })
                                                    ], id: \.0) { icon, action in
                                                        Button(action: action) {
                                                            ZStack {
                                                                Circle()
                                                                    .fill(.ultraThinMaterial)
                                                                    .frame(width: 40, height: 40)
                                                                    .overlay(
                                                                        Circle()
                                                                            .stroke(
                                                                                .linearGradient(
                                                                                    colors: [
                                                                                        .white.opacity(0.5),
                                                                                        .clear,
                                                                                        .white.opacity(0.2)
                                                                                    ],
                                                                                    startPoint: .topLeading,
                                                                                    endPoint: .bottomTrailing
                                                                                ),
                                                                                lineWidth: 1
                                                                            )
                                                                    )
                                                                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                                                                
                                                                Image(systemName: icon)
                                                                    .font(.system(size: 18, weight: .medium))
                                                                    .foregroundStyle(
                                                                        .linearGradient(
                                                                            colors: [.white, .white.opacity(0.8)],
                                                                            startPoint: .top,
                                                                            endPoint: .bottom
                                                                        )
                                                                    )
                                                            }
                                                        }
                                                        .scaleEffect(isHovering ? 1 : 0.8)
                                                        .opacity(isHovering ? 1 : 0)
                                                    }
                                                }
                                                .transition(.scale.combined(with: .opacity))
                                                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isHovering)
                                            }
                                        )
                                        .matchedGeometryEffect(id: "photo", in: animation)
                                }
                                .sheet(isPresented: $showingFullscreen) {
                                    ZStack {
                                        Color.black.ignoresSafeArea()
                                        filteredImage
                                            .scaledToFit()
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .padding()
                                            .gesture(
                                                MagnificationGesture()
                                                    .onChanged { value in
                                                        imageScale = value.magnitude
                                                    }
                                            )
                                    }
                                    .overlay(alignment: .topTrailing) {
                                        Button(action: { showingFullscreen = false }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(.white)
                                                .padding()
                                        }
                                    }
                                }
                                .sheet(isPresented: $showingFilterOptions) {
                                    NavigationView {
                                        List {
                                            Section(header: Text("Filters")) {
                                                ForEach(ImageFilter.allCases, id: \.self) { filter in
                                                    Button(action: {
                                                        withAnimation {
                                                            currentFilter = filter
                                                        }
                                                    }) {
                                                        HStack {
                                                            Text(filter.rawValue)
                                                            Spacer()
                                                            if currentFilter == filter {
                                                                Image(systemName: "checkmark")
                                                                    .foregroundColor(.blue)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            
                                            Section(header: Text("Adjustments")) {
                                                VStack {
                                                    HStack {
                                                        Text("Brightness")
                                                        Slider(value: $brightness, in: -0.5...0.5)
                                                    }
                                                    HStack {
                                                        Text("Contrast")
                                                        Slider(value: $contrast, in: 0.5...1.5)
                                                    }
                                                    HStack {
                                                        Text("Saturation")
                                                        Slider(value: $saturation, in: 0...2)
                                                    }
                                                }
                                            }
                                        }
                                        .navigationTitle("Image Adjustments")
                                        .navigationBarItems(trailing: Button("Done") {
                                            showingFilterOptions = false
                                        })
                                    }
                                }
                            } else {
                                // Enhanced upload prompt
                                VStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    colors: [Color.purple.opacity(0.2), Color.blue.opacity(0.2)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .frame(width: 56, height: 56)
                                        
                                        Image(systemName: "photo.on.rectangle.angled")
                                            .font(.system(size: 24))
                                            .foregroundStyle(
                                                LinearGradient(
                                                    colors: [.purple, .blue],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                    }
                                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                                    .animation(
                                        Animation.easeInOut(duration: 1.5)
                                            .repeatForever(autoreverses: true),
                                        value: isAnimating
                                    )
                                    
                                    VStack(spacing: 4) {
                                        Text("Drop your image here")
                                            .font(.system(size: 16, weight: .medium))
                                        Text("or click to browse")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 140)
                                .matchedGeometryEffect(id: "photo", in: animation)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            LinearGradient(
                                                colors: [.purple.opacity(0.3), .blue.opacity(0.3)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            style: StrokeStyle(
                                                lineWidth: 2,
                                                dash: [5]
                                            )
                                        )
                                )
                            }
                        }
                        .contentShape(Rectangle())
                        .onHover { hovering in
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isHovering = hovering
                            }
                        }
                    }
                    
                    // Enhanced info section
                    HStack(alignment: .center) {
                        // Left side info with animated icon
                        HStack(spacing: 6) {
                            Image(systemName: "info.circle")
                                .imageScale(.small)
                                .rotationEffect(.degrees(isHovering ? 360 : 0))
                                .animation(.easeInOut(duration: 1), value: isHovering)
                            Text("High-quality photos work best")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(.gray)
                        
                        Spacer()
                        
                        // Right side - clear button or upload info
                        if let _ = selectedImage {
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedImage = nil
                                    selectedItem = nil
                                    // Reset all adjustments
                                    currentFilter = .none
                                    brightness = 0
                                    contrast = 1
                                    saturation = 1
                                    rotationAngle = .zero
                                }
                            }) {
                                Label("Remove", systemImage: "xmark.circle.fill")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                            .buttonStyle(.plain)
                            .contentShape(Rectangle())
                            .scaleEffect(isHovering ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: isHovering)
                        } else {
                            Text("JPEG, PNG • Max 5MB")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
        }
        .onAppear {
            withAnimation {
                isAnimating = true
            }
        }
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: data) {
                        selectedImage = image
                    } else {
                        showErrorAlert = true
                        errorMessage = "Selected file is not a valid image"
                        selectedItem = nil
                    }
                }
            }
        }
        .alert("Invalid Selection", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
}

// Preview
struct EnhancedPhotoUpload_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            EnhancedPhotoUpload(
                selectedItem: .constant(nil),
                selectedImage: .constant(nil)
            )
            .padding()
        }
        .preferredColorScheme(.dark)
    }
}
