//
//  LoadNotesOperation.swift
//  Notes
//
//  Created by Николай Спиридонов on 03/08/2019.
//  Copyright © 2019 nnick. All rights reserved.
//

import Foundation
import CoreData

class LoadNotesOperation: AsyncOperation {
    private let loadFromDb: LoadNotesDBOperation
    private var loadFromBackend: LoadNotesBackendOperation
    
    init(backendQueue: OperationQueue,
         dbQueue: OperationQueue,
         backgroundContext: NSManagedObjectContext) {
        
        loadFromBackend = LoadNotesBackendOperation(backgroundContext: backgroundContext)
        loadFromDb = LoadNotesDBOperation(backgroundContext: backgroundContext)
        backendQueue.addOperation(loadFromBackend)
        
        super.init()

        loadFromBackend.completionBlock = {
            if let result = self.loadFromBackend.result {
                switch result {
                case .failure(.unreachable): print("Some error with server; load data from disk"); dbQueue.addOperation(self.loadFromDb)
                case .failure(.noNotes): print("0 notes on server") 
                case .failure(.fileNotExist): print("File ios-course-notes-db not exists on server; it will be created"); dbQueue.addOperation(self.loadFromDb)
                case .success(let notes): print("Notes successfully downloaded");  notesInCaseOfServerConntectionSuccess = notes
                }
            }
        }
        
    }
    
    override func main() {
        finish()
    }
}
