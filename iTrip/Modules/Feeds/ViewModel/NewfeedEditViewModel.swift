//
//  NewfeedEditViewModel.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/11/18.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import Combine
import SwiftUI

class NewfeedEditViewModel: ObservableObject {
    class IdentifiableImage: Identifiable, ObservableObject {
        let id = UUID()
        var image: UIImage!
        var addTag: Bool
        @Published var checked: Bool = false
        
        init(image: UIImage?, addTag: Bool=false) {
            self.image = image
            self.addTag = addTag
        }
    }
    
    enum PresentingType {
        case SelectAddress
        case SelectPhoto
    }
    enum FeedPostTipType {
        case lackphotos
        case confirm
    }
    
    let tripNode: TripNode
    private var images_: [UIImage] = [UIImage]()
    var presentingType: PresentingType = .SelectPhoto
    var postTipType: FeedPostTipType = .lackphotos
    var cancellable: AnyCancellable?
    
    // save succuess notification
    let newFeedPublisher: PassthroughSubject<Void, Never>
    
    var imageCount: Int {
        images_.count
    }
    
    @Published var images: [IdentifiableImage] = [IdentifiableImage(image: nil, addTag: true)]
    
    init(tripNode: TripNode, publisher: PassthroughSubject<Void, Never>) {
        self.tripNode = tripNode
        self.newFeedPublisher = publisher
    }
    
    func appendImages(_ newImages: [UIImage]) {
        images_.append(contentsOf: newImages)
        images.removeAll { (item) -> Bool in
            item.addTag == true
        }
        images.append(contentsOf: newImages.map({ (photo) -> IdentifiableImage in
            IdentifiableImage(image: photo)
        }))
        if images_.count < 6 {
            images.append(IdentifiableImage(image: nil, addTag: true))
        }
    }
    
    func cancelSelectedState() {
        images.forEach { (item) in
            if !item.addTag {
                item.checked = false
            }
        }
    }
    
    func deletingSelectedPhotos() {
        images.forEach { (item) in
            if item.checked {
                images_.removeAll { (image) -> Bool in
                    item.image == image
                }
            }
        }
        images.removeAll { (item) -> Bool in
            item.checked
        }
    }
    
    func saveFeed(tip: String, addressState: TripAddressState) -> AnyPublisher<Void, Never> {
        return Future<Void, Never>.init { (promise) in
            DispatchQueue.global().async {
                let feed = StrorageHelper.createEntity() as Feed
                feed.content = tip
                let address = TripAddress()
                address.syncData(from: addressState)
                feed.address = address
                for img in self.images_ {
                    let photo = StrorageHelper.createEntity() as FeedPhoto
                    photo.localFileName = ImageController.shared.saveImage(image: img)
                    feed.addToPhotos(photo)
                }
                feed.postDate = Date()
                self.tripNode.addToFeeds(feed)
                StrorageHelper.save()
                promise(.success(Void()))
            }
        }.receive(on: DispatchQueue.main).handleEvents(receiveOutput:  { _ in
            self.newFeedPublisher.send()
        }).eraseToAnyPublisher()
    }
}
