import SwiftUI

struct ColorAdjustableImage: View {
    let imageName: String
    let height: CGFloat?
    let width: CGFloat?
    let adjustmentColor: Color
   
    @Binding var colorIntensity: CGFloat
    
    @State private var originalImage: UIImage?
    @State private var processedImage: UIImage?
    
    // MARK: - Initialization
    init(imageName: String, height: CGFloat? = nil, width: CGFloat? = nil, adjustmentColor: Color, colorIntensity: Binding<CGFloat>) {
        self.imageName = imageName
        self.height = height
        self.width = width
        self.adjustmentColor = adjustmentColor
        self._colorIntensity = colorIntensity
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            if let image = processedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: width ?? CGFloat(UIScreen.main.bounds.width * 0.3),
                        height: height ?? CGFloat(UIScreen.main.bounds.width * 0.3)
                    )
                    .cornerRadius(10)
                    .clipped()
            } else {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: width ?? CGFloat(UIScreen.main.bounds.width * 0.3),
                        height: height ?? CGFloat(UIScreen.main.bounds.width * 0.3)
                    )
                    .cornerRadius(10)
                    .clipped()
                    .onAppear {
                        loadAndProcessImage()
                    }
            }
        }
        .onChange(of: colorIntensity) { newValue in
            adjustColor()
        }
    }
    
    // MARK: - Private Methods
    private func loadAndProcessImage() {
        guard let image = UIImage(named: imageName) else { return }
        originalImage = image
        processedImage = image
        adjustColor()
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

struct ColorAdjustableImage_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview with default size
            ColorAdjustableImage(
                imageName: "bg-1",
                adjustmentColor: .blue,
                colorIntensity: .constant(0.9)
            )
            
            // Preview with custom size
            ColorAdjustableImage(
                imageName: "bg-1",
                height: 200,
                width: 200,
                adjustmentColor: .blue,
                colorIntensity: .constant(0.9)
            )
        }
    }
}
