//
//  Feed+CoreDataClass.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/26.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//
//

import SwiftUI
import CoreData

@objc(Feed)
public class Feed: NSManagedObject {

}

extension Feed {
    var avatarUrl: URL {
        return URL.init(string: posterAvatar!)!
    }
    
    var feedPhotoUrl: URL {
        return URL.init(string: testPhoto!)!
    }
    
    var feedPhotoArray: Array<FeedPhoto> {
        return Array<FeedPhoto>((photos as? Set<FeedPhoto>) ?? []).sorted { (photo1, photo2) -> Bool in
            photo1.localFileName! >= photo2.localFileName!
        }
    }
    
    static func feedsForInstaSection(number: Int = 5) -> [Feed]
    {
        let feeds = (0 ..< number).map
        { b -> Feed in
            return Feed.randomFeed(id: b)
        }
        print(feeds.count)
        return feeds
    }
    
    static func randomFeed(id: Int) -> Feed
    {
        let feed: Feed = StrorageHelper.createEntity()
        feed.poster = Lorem.fullName
        let address = TripAddress()
        address.name = Lorem.words(Int.random(in: 1 ... 3))
        feed.address = address
        feed.id = "\(id)"
        feed.content = Lorem.sentences(1 ... 3)
        feed.posterAvatar = "https://picsum.photos/100?random=\(Int.random(in: 0 ... 500))"
        feed.testPhoto = "https://picsum.photos/\(Int(1 * 500))/500?random=\(abs(10 + [1, 2, 3].randomElement()!))"
        return feed
    }
}
