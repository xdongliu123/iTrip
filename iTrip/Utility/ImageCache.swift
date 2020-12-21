//
//  ImageCache.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/11/23.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import UIKit

// Declares in-memory image cache
protocol ImageCacheType: class {
    // Returns the image associated with a given url
    func image(for key: AnyObject) -> UIImage?
    // Inserts the image of the specified url in the cache
    func insertImage(_ image: UIImage?, for key: AnyObject)
    // Removes the image of the specified url in the cache
    func removeImage(for key: AnyObject)
    // Removes all images from the cache
    func removeAllImages()
    // Accesses the value associated with the given key for reading and writing
    subscript(_ key: AnyObject) -> UIImage? { get set }
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
}

extension ImageCache: ImageCacheType {
    subscript(_ key: AnyObject) -> UIImage? {
        get {
            return image(for: key)
        }
        set {
            return insertImage(newValue, for: key)
        }
    }
    
    func image(for key: AnyObject) -> UIImage? {
        lock.lock(); defer { lock.unlock() }
        // the best case scenario -> there is a decoded image
        if let decodedImage = decodedImageCache.object(forKey: key) as? UIImage {
            return decodedImage
        }
        // search for image data
        if let image = imageCache.object(forKey: key) as? UIImage {
            let decodedImage = image.decodedImage()
            decodedImageCache.setObject(image as AnyObject, forKey: key, cost: decodedImage.diskSize)
            return decodedImage
        }
        return nil
    }
    
    func insertImage(_ image: UIImage?, for key: AnyObject) {
        guard let image = image else { return removeImage(for: key) }
        let decodedImage = image.decodedImage()

        lock.lock(); defer { lock.unlock() }
        imageCache.setObject(image, forKey: key)
        decodedImageCache.setObject(decodedImage as AnyObject, forKey: key, cost: decodedImage.diskSize)
    }

    func removeImage(for key: AnyObject) {
        lock.lock(); defer { lock.unlock() }
        imageCache.removeObject(forKey: key)
        decodedImageCache.removeObject(forKey: key)
    }
    
    func removeAllImages() {
        lock.lock(); defer { lock.unlock() }
        imageCache.removeAllObjects()
        decodedImageCache.removeAllObjects()
    }
}
