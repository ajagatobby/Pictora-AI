import SwiftUI

// Header Component
struct PresetHeaderView: View {
    var showAllPresets: Binding<Bool>
    
    var body: some View {
        HStack {
            Typography(label: "Presets", variants: .body2, color: .white)
            Spacer()
            Button {
                showAllPresets.wrappedValue = true
            } label: {
                HStack {
                    Text("See More")
                        .font(.fkDisplay(.regularAlt, size: 14))
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                }
                .foregroundStyle(
                    LinearGradient(
                        colors: [.purple.opacity(0.8), .blue.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            }
        }
    }
}

// Horizontal Scroll Component
struct PresetScrollView: View {
    var selectedPreset: Binding<Preset?>
    var presets: [Preset]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Array(presets.prefix(6)), id: \.id) { preset in
                    PresetCard(
                        selected: selectedPreset.wrappedValue?.id == preset.id,
                        label: preset.name,
                        imageName: preset.imageUrl,
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

// All Presets Sheet Content
struct AllPresetsView: View {
    @Binding var showAllPresets: Bool
    @Binding var selectedPreset: Preset?
    @Binding var searchText: String
    var filteredPresets: [Preset]
    
    var body: some View {
        NavigationView {
            ZStack {
                GradientBackground()
                
                VStack(spacing: 16) {
                    SearchBar(text: $searchText)
                        .padding(.horizontal)
                    
                    HStack {
                        Typography(
                            label: "\(filteredPresets.count) Presets",
                            variants: .body1,
                            color: .gray
                        )
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    ScrollView {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12)
                            ],
                            spacing: 16
                        ) {
                            ForEach(filteredPresets, id: \.id) { preset in
                                PresetCard(
                                    selected: selectedPreset?.id == preset.id,
                                    label: preset.name,
                                    imageName: preset.imageUrl,
                                    perform: {
                                        selectedPreset = preset
                                    }
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("All Presets")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAllPresets = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white.opacity(0.8), .white.opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.black.opacity(0.8), for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .preferredColorScheme(.dark)
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}

// Main View
struct PresetGridView: View {
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
            PresetHeaderView(showAllPresets: $showAllPresets)
            
            PresetScrollView(selectedPreset: $selectedPreset, presets: presets)
        }
        .sheet(isPresented: $showAllPresets) {
            AllPresetsView(
                showAllPresets: $showAllPresets,
                selectedPreset: $selectedPreset,
                searchText: $searchText,
                filteredPresets: filteredPresets
            )
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        PresetGridView()
            .padding()
    }
}
