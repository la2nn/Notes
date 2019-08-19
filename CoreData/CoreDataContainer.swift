//
//  CoreDataContainer.swift
//  sportApp
//
//  Created by Николай Спиридонов on 18/08/2019.
//  Copyright © 2019 nnick. All rights reserved.
//

import UIKit
import CoreData

class CoreDataContainer {
    var backgroundContext: NSManagedObjectContext
    var context: NSManagedObjectContext
    
    // MARK: - CoreData Stack
    
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Notes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    init() {
        self.backgroundContext = persistentContainer.newBackgroundContext()
        self.context = persistentContainer.viewContext
    }
    
}
