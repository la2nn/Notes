//
//  RemoveNoteDBOperation.swift
//  Notes
//
//  Created by Николай Спиридонов on 03/08/2019.
//  Copyright © 2019 nnick. All rights reserved.
//

import UIKit
import CoreData

class RemoveNoteDBOperation: BaseDBOperation {
    
    init(note: Note, backgroundContext: NSManagedObjectContext) {
        super.init(context: backgroundContext)
        
        removeNoteMO(backgroundContext: backgroundContext, noteUID: note.uid)
 
    }
    
    override func main() {
        finish()
    }
}

func removeNoteMO(backgroundContext: NSManagedObjectContext, noteUID: String) {
    let request: NSFetchRequest<NoteMO> = NoteMO.fetchRequest()
    request.predicate = NSPredicate(format: "uid == %@", noteUID)
    
    var noteMO: NoteMO?
    do {
        noteMO = try backgroundContext.fetch(request).first
    } catch {
        print(error.localizedDescription)
    }
    guard let noteMONotNil = noteMO else { print("SOMETHING WRONG WHEN YOU REMOVE NOTE") ; return }
    backgroundContext.delete(noteMONotNil)
    backgroundContext.performAndWait {
        do {
            try backgroundContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
