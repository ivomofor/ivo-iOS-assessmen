//
//  ImageCache.swift
//  About-You
//
//

import Foundation
import UIKit

// Declares in-memory image cache
protocol ImageCacheType: AnyObject {
    // Returns the image associated with a given url
    func image(for url: URL) -> UIImage?
    // Inserts the image of the specified url in the cache
    func insertImage(_ image: UIImage?, for url: URL)
    // Removes the image of the specified url in the cache
    func removeImage(for url: URL)
    // Removes all images from the cache
    func removeAllImages()
    // Accesses the value associated with the given key for reading and writing
    subscript(_ url: URL) -> UIImage? { get set }
}


final class ImageCache {
    
    // 1st level cache, that contains encoded images
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = config.countLimit
        return cache
    }()
    // 2nd level cache, that contains decoded images
    private lazy var decodedImageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.totalCostLimit = config.memoryLimit
        return cache
    }()
    private let lock = NSLock()
    private let config: Config
    
    struct Config {
        let countLimit: Int
        let memoryLimit: Int
        
        static let defaultConfig = Config(countLimit: 100, memoryLimit: 1024 * 1024 * 100) // 100 MB
    }
    
    init(config: Config = Config.defaultConfig) {
        self.config = config
    }
    
    //Note: This is setting the key to the url value which acts as key to fetch the image but this wipes off as soon as app goes to background
    func setCustomValue(for key: String, value: Any) {
        imageCache.setObject(value as AnyObject, forKey: key as AnyObject)
    }
    
    func fetchCustomValue(for key: String) -> URL? {
        return imageCache.object(forKey: key as AnyObject) as? URL
    }
}

extension ImageCache: ImageCacheType {
    func image(for url: URL) -> UIImage? {
        lock.lock(); defer { lock.unlock() }
        // the best case scenario -> there is a decoded image
        if let decodedImage = decodedImageCache.object(forKey: url as AnyObject) as? UIImage {
            return decodedImage
        }
        // search for image data
        if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
            decodedImageCache.setObject(image as AnyObject, forKey: url as AnyObject)
            return image
        }
        return nil
    }
    
    func removeAllImages() {
        //do nothing for now
    }
    
    subscript(url: URL) -> UIImage? {
        get {
            return image(for: url)
        }
        set {
            return insertImage(newValue, for: url)
        }
    }
    
    func insertImage(_ image: UIImage?, for url: URL) {
        guard let image = image else { return removeImage(for: url) }
        
        lock.lock(); defer { lock.unlock() }
        imageCache.setObject(image, forKey: url as AnyObject)
        decodedImageCache.setObject(image as AnyObject, forKey: url as AnyObject)
    }
    
    func removeImage(for url: URL) {
        lock.lock(); defer { lock.unlock() }
        imageCache.removeObject(forKey: url as AnyObject)
        decodedImageCache.removeObject(forKey: url as AnyObject)
    }
}

final class ImageLoader {
    private let cache = ImageCache()
    static let shared = ImageLoader()

    func loadImage(from url: URL, image: UIImage) {
        self.cache[url] = image
    }
    
    func fetchImage(from url: URL) -> UIImage? {
        if let image = cache[url] {
            return image
        }
        return nil
    }
}

extension ImageLoader {
    func mapImageUrlWithEngineer(id: String, profileImageUrl: URL) {
        cache.setCustomValue(for: id, value: profileImageUrl)
    }
    
    func imageUrl(id: String) -> URL? {
        return cache.fetchCustomValue(for: id)
    }
}
