//
//  NavController.swift
//  Notes
//
//  Created by Николай Спиридонов on 03/08/2019.
//  Copyright © 2019 nnick. All rights reserved.
//

import UIKit

class NotesNavigationController: UINavigationController {

    var notebook = FileNotebook()
    let backendQueue = OperationQueue()
    let dbQueue = OperationQueue()
    let loadNotesQueue = OperationQueue()
    let removeNoteQueue = OperationQueue()
    let saveNotesQueue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sleep(1)
        loadNotesQueue.addOperation(LoadNotesOperation(notebook: notebook, backendQueue: backendQueue, dbQueue: dbQueue))
        sleep(3)
    }
    
}

