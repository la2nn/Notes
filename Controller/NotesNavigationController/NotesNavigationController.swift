//
//  NavController.swift
//  Notes
//
//  Created by Николай Спиридонов on 03/08/2019.
//  Copyright © 2019 nnick. All rights reserved.
//

import UIKit
import CoreData

class NotesNavigationController: UINavigationController {

    let backendQueue = OperationQueue()
    let dbQueue = OperationQueue()
    let loadNotesQueue = OperationQueue()
    let removeNoteQueue = OperationQueue()
    let saveNotesQueue = OperationQueue()
    
    var backgroundContext: NSManagedObjectContext!
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coreDataContainer = CoreDataContainer()
        self.backgroundContext = coreDataContainer.backgroundContext
        self.context = coreDataContainer.context
        
        sleep(1)
        loadNotesQueue.addOperation(LoadNotesOperation(backendQueue: backendQueue, dbQueue: dbQueue, backgroundContext: backgroundContext))
        sleep(3)
    }
    
}

