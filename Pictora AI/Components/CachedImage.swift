import SwiftUI

struct CachedNetworkImage<Placeholder: View>: View {
    @StateObject private var viewModel: NetworkImageViewModel
    @State private var loadingOpacity: Double = 0
    @State private var imageOpacity: Double = 0
    let placeholder: Placeholder
    let animation: Animation?
    
    init(url: String, blurHash: String? = nil, @ViewBuilder placeholder: () -> Placeholder, animation: Animation? = .default) {
        _viewModel = StateObject(wrappedValue: NetworkImageViewModel(url: url))
        self.placeholder = placeholder()
        self.animation = animation
    }
    
    var body: some View {
        Group {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .opacity(imageOpacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 0.3)) {
                            imageOpacity = 1
                        }
                    }
                    .onDisappear {
                        imageOpacity = 0
                    }
            } else if viewModel.isLoading {
                ProgressView()
            } else if viewModel.error != nil {
                placeholder
                    .opacity(loadingOpacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 0.3)) {
                            loadingOpacity = 1
                        }
                    }
            } else {
                placeholder
                    .opacity(loadingOpacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 0.3)) {
                            loadingOpacity = 1
                        }
                    }
            }
        }
    }
}

extension CachedNetworkImage where Placeholder == Image {
    init(url: String,  animation: Animation? = .default) {
        self.init(url: url, placeholder: { Image(systemName: "photo") }, animation: animation)
    }
}
