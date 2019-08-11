//
//  RemoveNoteOperation.swift
//  Notes
//
//  Created by Николай Спиридонов on 03/08/2019.
//  Copyright © 2019 nnick. All rights reserved.
//

import Foundation

class RemoveNoteOperation: AsyncOperation {
    private let noteUID: String
    private let notebook: FileNotebook
    private let removeDBOperation: RemoveNoteDBOperation
    private var saveToBackend: SaveNotesBackendOperation
    
    init(noteUID: String, notebook: FileNotebook, backendQueue: OperationQueue, dbQueue: OperationQueue) {
        self.noteUID = noteUID
        self.notebook = notebook
    
        removeDBOperation = RemoveNoteDBOperation(notebook: notebook, noteUID: noteUID)
        saveToBackend = SaveNotesBackendOperation(notes: notebook.notes)
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
