//
//  DataController.swift
//  Delta
//
//  Created by Dino Constantinou on 13/01/2018.
//  Copyright © 2018 Dino Constantinou. All rights reserved.
//

import CoreData

class DataController {
    
    // MARK: - Init
    
    init() {
        container = NSPersistentContainer(name: "Delta")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Error loading stores: \(error)")
            }
        })
    }
    
    // MARK: - Computed Properties
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }

    // MARK: - Static Properties
    
    static let main: DataController = DataController()
    
    // MARK: - Stored Properties
    
    private let container: NSPersistentContainer
    
}
