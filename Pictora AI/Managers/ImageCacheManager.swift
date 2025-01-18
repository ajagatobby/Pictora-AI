import Foundation
import UIKit

actor ImageCacheManager {
    static let instance = ImageCacheManager()
    
    private init() { }
    
    private var imageCache: NSCache<NSString, CachedImage> = {
        let cache = NSCache<NSString, CachedImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 1000 // 1GB
        return cache
    }()
    
    private var cacheKeys: [String] = []
    
    func add(image: UIImage, key: String) {
        let cachedImage = CachedImage(image: image, lastAccessed: Date())
        imageCache.setObject(cachedImage, forKey: key as NSString)
        if !cacheKeys.contains(key) {
            cacheKeys.append(key)
        }
        print("Added to image cache: \(key)")
    }
    
    func get(key: String) -> UIImage? {
        guard let cachedImage = imageCache.object(forKey: key as NSString) else {
            print("Image not found in cache: \(key)")
            return nil
        }
        cachedImage.lastAccessed = Date()
        print("Returned image from cache: \(key)")
        return cachedImage.image
    }
    
    func remove(key: String) {
        imageCache.removeObject(forKey: key as NSString)
        if let index = cacheKeys.firstIndex(of: key) {
            cacheKeys.remove(at: index)
        }
        print("Removed from cache: \(key)")
    }
    
    func clearCache() {
        imageCache.removeAllObjects()
        cacheKeys.removeAll()
        print("Cache cleared")
    }
    
    func cleanupOldEntries(olderThan: TimeInterval) {
        let now = Date()
        for key in cacheKeys {
            if let cachedImage = imageCache.object(forKey: key as NSString),
               now.timeIntervalSince(cachedImage.lastAccessed) > olderThan {
                remove(key: key)
            }
        }
    }
}

class CachedImage {
    let image: UIImage
    var lastAccessed: Date
    
    init(image: UIImage, lastAccessed: Date) {
        self.image = image
        self.lastAccessed = lastAccessed
    }
}
