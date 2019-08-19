//
//  RemoveNoteOperation.swift
//  Notes
//
//  Created by Николай Спиридонов on 03/08/2019.
//  Copyright © 2019 nnick. All rights reserved.
//

import UIKit
import CoreData

class RemoveNoteOperation: AsyncOperation {
    private let noteUID: String
    private let removeDBOperation: RemoveNoteDBOperation
    private var saveToBackend: SaveNotesBackendOperation
    
    init(note: Note, backendQueue: OperationQueue, dbQueue: OperationQueue, backgroundContext: NSManagedObjectContext) {
        self.noteUID = note.uid
        
        removeDBOperation = RemoveNoteDBOperation(note: note, backgroundContext: backgroundContext)
        saveToBackend = SaveNotesBackendOperation(notes: notesFromCoreData)
        super.init()

        dbQueue.addOperation(removeDBOperation)

        self.addDependency(saveToBackend)
        
        removeDBOperation.completionBlock = {
            backendQueue.addOperation(self.saveToBackend)
        }
        
    }

    override func main() {
        self.finish()
    }

}
