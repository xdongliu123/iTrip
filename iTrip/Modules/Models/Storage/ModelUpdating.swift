//
//  ModelUpdating.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/19.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import CoreData
import UIKit

protocol ModelUpdating {
    func updateModel(with jsonDic: [String : Any]);
    func parseJson(with dictionary: [String : Any]);
}

extension ModelUpdating where Self: NSManagedObject {
    func updateModel(with jsonDic: [String : Any]) {
        self.parseJson(with: jsonDic)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
}
