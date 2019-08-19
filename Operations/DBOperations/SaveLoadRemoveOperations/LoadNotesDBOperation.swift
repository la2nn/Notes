//
//  LoadNotesDBOperation.swift
//  Notes
//
//  Created by Николай Спиридонов on 03/08/2019.
//  Copyright © 2019 nnick. All rights reserved.
//

import UIKit
import CoreData

class LoadNotesDBOperation: BaseDBOperation {
    let backgroundContext: NSManagedObjectContext
    
    init(backgroundContext: NSManagedObjectContext) {
        self.backgroundContext = backgroundContext
        super.init(context: backgroundContext)
    }
    
    override func main() {
        loadFromCoreData(backgroundContext: self.backgroundContext)
        finish()
    }
    
    func loadFromCoreData(backgroundContext: NSManagedObjectContext) {
        let request: NSFetchRequest<NoteMO> = NoteMO.fetchRequest()
        
        do {
            let notesMO = try backgroundContext.fetch(request)
            if notesMO.count == 0 {
                notesFromCoreData = []
                return
            }
            for note in notesMO {
                let noteColor = note.noteColor as! NSDictionary
                let r = noteColor["red"] as! CGFloat
                let g = noteColor["green"] as! CGFloat
                let b = noteColor["blue"] as! CGFloat
                let a = noteColor["alpha"] as! CGFloat
                
                let newNote = Note(uid: note.uid, title: note.title, content: note.content, noteColor: UIColor(red: r, green: g, blue: b, alpha: a), importance: Importance(rawValue: "\(note.importance)")!, selfDestructionDate: note.destuctionDate as Date?)
                notesFromCoreData.append(newNote)
            }
            print("Notes from CoreData: \(notesFromCoreData.count)")
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
}

