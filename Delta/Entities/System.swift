//
//  System.swift
//  Delta
//
//  Created by Dino Constantinou on 14/01/2018.
//  Copyright © 2018 Dino Constantinou. All rights reserved.
//

import CoreData

extension System {
    
    class func system(for identifier: String, context: NSManagedObjectContext) throws -> System? {
        let request: NSFetchRequest<System> = fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(System.identifier), identifier)
        request.fetchLimit = 1
        
        let result = try context.fetch(request)
        return result.first
    }
    
}
