//
//  LoadNotesOperation.swift
//  Notes
//
//  Created by Николай Спиридонов on 03/08/2019.
//  Copyright © 2019 nnick. All rights reserved.
//

import Foundation

class LoadNotesOperation: AsyncOperation {
    private let notebook: FileNotebook
    private let loadFromDb: LoadNotesDBOperation
    private var loadFromBackend: LoadNotesBackendOperation
    
    init(notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        self.notebook = notebook
        
        loadFromDb = LoadNotesDBOperation(notebook: notebook)
        loadFromBackend = LoadNotesBackendOperation(notes: nil)
        
        super.init()

        dbQueue.addOperation(loadFromDb)
        backendQueue.addOperation(loadFromBackend)
    }
    
    override func main() {
        switch loadFromBackend.result! {
        case .success(let notes):
            print("Заметки успешно загружены с сервера!")
            notesInCaseOfServerConntectionSuccess = notes
            // В случае загрузки заметок с сервера, заменяем заметки на диске
            // Замена осуществляется в NotesTableViewController в методе ViewWillAppear
        case .failure:
            break
        }
        
        finish()
    }
}
