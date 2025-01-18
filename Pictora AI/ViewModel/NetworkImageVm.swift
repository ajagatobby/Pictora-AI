import Foundation
import UIKit

@MainActor
class NetworkImageViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    @Published var error: Error?
    
    private let urlString: String
    private let manager = ImageCacheManager.instance
    private var cancellable: Task<Void, Never>?
    
    init(url: String) {
        self.urlString = url
        loadImage()
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    func loadImage() {
        cancellable?.cancel()
        cancellable = Task {
            await fetchImage()
        }
    }
    
    private func fetchImage() async {
        isLoading = true
        error = nil
        
        defer { isLoading = false }
        
        if let cachedImage = await manager.get(key: urlString) {
            image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else {
            error = URLError(.badURL)
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                throw URLError(.badServerResponse)
            }
            
            guard let downloadedImage = UIImage(data: data) else {
                throw URLError(.cannotDecodeContentData)
            }
            
            image = downloadedImage
            await manager.add(image: downloadedImage, key: urlString)
        } catch {
            self.error = error
        }
    }
    
    func removeFromCache() async {
        await manager.remove(key: urlString)
        image = nil
    }
}
