import SwiftUI

struct NetworkColorAdjustableImage: View {
    // MARK: - Properties
    let imageURL: String
    let adjustmentColor: Color
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    @Binding var colorIntensity: CGFloat
    
    @State private var originalImage: UIImage?
    @State private var processedImage: UIImage?
    @State private var isLoading: Bool = false
    @State private var loadError: Error?
    
    // MARK: - Initialization
    init(
        imageURL: String,
        adjustmentColor: Color,
        width: CGFloat = 100,
        height: CGFloat = 100,
        cornerRadius: CGFloat = 10,
        colorIntensity: Binding<CGFloat>
    ) {
        self.imageURL = imageURL
        self.adjustmentColor = adjustmentColor
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self._colorIntensity = colorIntensity
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            if let image = processedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .cornerRadius(cornerRadius)
                    .clipped()
            } else if isLoading {
                ProgressView()
                    .frame(width: width, height: height)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(cornerRadius)
            } else if loadError != nil {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: min(width, height) * 0.3)) // Scale icon size relative to frame
                    .foregroundColor(.red)
                    .frame(width: width, height: height)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(cornerRadius)
            } else {
                Color.gray.opacity(0.1)
                    .frame(width: width, height: height)
                    .cornerRadius(cornerRadius)
                    .onAppear {
                        loadNetworkImage()
                    }
            }
        }
        .onChange(of: colorIntensity) { newValue in
            adjustColor()
        }
    }
    
    // MARK: - Private Methods
    private func loadNetworkImage() {
        guard let url = URL(string: imageURL) else {
            loadError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            return
        }
        
        isLoading = true
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    loadError = error
                    return
                }
                
                guard let data = data, let downloadedImage = UIImage(data: data) else {
                    loadError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to load image"])
                    return
                }
                
                originalImage = downloadedImage
                processedImage = downloadedImage
                adjustColor()
            }
        }.resume()
    }
    
    private func adjustColor() {
        guard let originalImage = originalImage else { return }
        guard let ciImage = CIImage(image: originalImage) else { return }
        
        let colorFilter = CIFilter(name: "CIColorMatrix")
        colorFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        // Convert SwiftUI Color to UIColor, then to RGB components
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        UIColor(adjustmentColor).getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        // Create color matrix with intensity adjustment
        let colorMatrix: [CGFloat] = [
            1 + (red * colorIntensity), 0, 0, 0,
            0, 1 + (green * colorIntensity), 0, 0,
            0, 0, 1 + (blue * colorIntensity), 0,
            0, 0, 0, 1
        ]
        
        colorFilter?.setValue(CIVector(values: colorMatrix, count: 16), forKey: "inputRVector")
        
        if let outputImage = colorFilter?.outputImage {
            let context = CIContext()
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                processedImage = UIImage(cgImage: cgImage)
            }
        }
    }
}

// MARK: - Preview Provider
struct NetworkColorAdjustableImage_Previews: PreviewProvider {
    static var previews: some View {
        NetworkColorAdjustableImage(
            imageURL: "https://example.com/image.jpg",
            adjustmentColor: .blue,
            width: 200,
            height: 150,
            cornerRadius: 15,
            colorIntensity: .constant(0.9)
        )
    }
}
