import SwiftUI


// Horizontal Scroll Component
struct SignatureScrollView: View {
    var selectedPreset: Binding<Preset?>
    var presets: [Preset]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Array(signaturePresets.prefix(6)), id: \.id) { preset in
                    SignaturePresetCard(
                        selected: selectedPreset.wrappedValue?.id == preset.id,
                        label: preset.name,
                        imageName: preset.imageUrl,
                        isPremium: false,
                        perform: {
                            selectedPreset.wrappedValue = preset
                        }
                    )
                }
            }
            .padding(.horizontal, 4)
        }
    }
}

// Main View
struct SignaturePresetGrid: View {
    @State private var showAllPresets = false
    @State private var searchText = ""
    @State private var selectedPreset: Preset?
    
    var filteredPresets: [Preset] {
        if searchText.isEmpty {
            return presets
        }
        return presets.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            SignatureScrollView(selectedPreset: $selectedPreset, presets: presets)
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        SignaturePresetGrid()
            .padding()
    }
}
