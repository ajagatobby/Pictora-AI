import SwiftUI

struct FormatButton: View {
    let format: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(format)
                .font(.fkDisplay(.regular, size: 14))
                .foregroundColor(isSelected ? .white : .gray)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? Color.white.opacity(0.1) : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [
                                            .white.opacity(isSelected ? 0.3 : 0.1),
                                            .clear
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 0.5
                                )
                        )
                )
        }
    }
}

struct AdvancedSettings: View {
    @State private var selectedRatio: String = "4:5"
    @State private var selectedFormat: String = "PNG"
    @State private var seed: String = "random seed"
    @State private var quality: Double = 0.7
    @State private var negativePrompt: String = ""
    @FocusState var negativePromptFocused: Bool
    
    let ratios = ["1:1", "4:5", "5:4", "2:3", "3:2", "9:16"]
    let formats = ["PNG", "JPEG", "WebP", "AVIF"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Aspect Ratio Section
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Typography(label: "Aspect Ratio", variants: .body2, color: .white)
                    Spacer()
                    Text(selectedRatio)
                        .font(.fkDisplay(.regular, size: 12))
                        .foregroundColor(.gray)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(ratios, id: \.self) { ratio in
                            AspectRatioButton(
                                ratio: ratio,
                                isSelected: selectedRatio == ratio,
                                action: { selectedRatio = ratio }
                            )
                        }
                    }
                    .padding(.horizontal, 1)
                }
            }
            
            // Negative Prompt Section
            VStack(alignment: .leading, spacing: 12) {
                Typography(label: "Don't include:", variants: .body2, color: .white)
                TextField("Enter things to exclude...", text: $negativePrompt)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.fkDisplay(.regular, size: 16))
                    .foregroundColor(.white)
                    .focused($negativePromptFocused)
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [.white.opacity(0.2), .clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 0.5
                            )
                    )
                    .cornerRadius(12)
            }
            
            // Quality Slider Section
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Typography(label: "Quality", variants: .body2, color: .white)
                    Spacer()
                    Text("\(Int(quality * 100))%")
                        .font(.fkDisplay(.regular, size: 12))
                        .foregroundColor(.gray)
                }
                
                Slider(value: $quality, in: 0...1)
                    .tint(
                        LinearGradient(
                            colors: [.purple.opacity(0.8), .blue.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .overlay(
                        GeometryReader { geometry in
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [.white.opacity(0.2), .clear],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 2, height: 10)
                                .position(
                                    x: geometry.size.width * CGFloat(quality),
                                    y: geometry.size.height / 2
                                )
                        }
                    )
            }
            
            // Output Format Section
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Typography(label: "Output Format", variants: .body2, color: .white)
                    Spacer()
                    Text(selectedFormat)
                        .font(.fkDisplay(.regular, size: 12))
                        .foregroundColor(.gray)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(formats, id: \.self) { format in
                            FormatButton(
                                format: format,
                                isSelected: selectedFormat == format,
                                action: { selectedFormat = format }
                            )
                        }
                    }
                    .padding(.horizontal, 1)
                }
            }
        }
        .padding()
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
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        AdvancedSettings(negativePromptFocused: FocusState<Bool>())
            .padding()
    }
}
