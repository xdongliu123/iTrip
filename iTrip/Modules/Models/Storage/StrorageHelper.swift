//
//  StrorageHelper.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/19.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import CoreData
import UIKit

class StrorageHelper {
    static func createEntity<T: NSManagedObject>() -> T {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return T(context: context)
    }
    
    static func findAllObjects<T: NSManagedObject>(sorters: [NSSortDescriptor]=[], predicate: NSPredicate?=nil) -> [T] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var results: [T] = []
        if let request = T.fetchRequest() as? NSFetchRequest<T> {
            request.predicate = predicate
            request.sortDescriptors = sorters;
            do {
                results = try context.fetch(request)
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        return results
    }
    
    static func delete(model: NSManagedObject) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(model)
        save()
    }
    
    static func save() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
}
