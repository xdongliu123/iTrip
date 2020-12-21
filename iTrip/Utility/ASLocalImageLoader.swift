//
//  ASLocalImageLoader.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/11/23.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import Combine
import UIKit

class ASLocalImageManager {
    static let shared = ASLocalImageManager()
    public init(cache: ImageCacheType = ImageCache()) {
        self.cache = cache
    }
    
    private let cache: ImageCacheType
    private lazy var backgroundQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
    
    public func loadImage(from fileName: String) -> AnyPublisher<UIImage?, Never> {
        if let image = cache[fileName as AnyObject] {
            return Just(image)
                   .eraseToAnyPublisher()
        }
        let future = Future<UIImage?, Never>.init { (promise) in
            DispatchQueue.global().async {
                // print(Thread.isMainThread)
                if let image = ImageController.shared.fetchImage(imageName: fileName) {
                    self.cache[fileName as AnyObject] = image
                    promise(.success(image))
                } else {
                    promise(.success(nil))
                }
            }
        }
        return future.subscribe(on: DispatchQueue.global())
                     .delay(for: 1, scheduler: DispatchQueue.global())
                     .receive(on: RunLoop.main)
                     .eraseToAnyPublisher()
    }
}


class ASLocalImageLoader: ObservableObject {
    var fileName: String
    var subscription: AnyCancellable? = nil

    init(_ fileName: String) {
        self.fileName = fileName
    }

    @Published var image: UIImage? = nil

    func startLoad() {
        subscription = ASLocalImageManager.shared.loadImage(from: fileName)
            .handleEvents(receiveOutput: { (image) in
                // print("image")
            })
            .assign(to: \.image, on: self)
    }
    
    func cancel() {
        subscription?.cancel()
        subscription = nil
    }
}
