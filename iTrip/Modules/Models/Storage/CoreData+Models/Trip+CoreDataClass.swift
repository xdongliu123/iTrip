//
//  Trip+CoreDataClass.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/14.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Trip)
public class Trip: NSManagedObject {

}

extension Trip {
    func uiImageCover() -> UIImage? {
        return cover != nil ? UIImage(data: cover!)!.withRenderingMode(.alwaysOriginal) : nil
    }
}

extension Trip: Identifiable {

}

extension Trip: ModelUpdating {
    enum ParsingKeys {
        static let name = "name"
        static let destination = "destination"
        static let startDate = "startDate"
        static let endDate = "endDate"
        static let desc = "description"
        static let cover = "cover"
    }

    func parseJson(with dictionary: [String : Any]) {
        if let name = dictionary[ParsingKeys.name] as? String {
            self.name = name
        }
        
        if let destination = dictionary[ParsingKeys.destination] as? String {
            self.destination = destination
        }
        
        if let desc = dictionary[ParsingKeys.desc] as? String {
            self.desc = desc
        }
        
        if let startDate = dictionary[ParsingKeys.startDate] as? Date {
            self.startDate = startDate
        }
        
        if let endDate = dictionary[ParsingKeys.endDate] as? Date {
            self.endDate = endDate
        }
        
        if let cover = dictionary[ParsingKeys.cover] as? UIImage {
            self.cover = cover.pngData()
        }
    }
}
