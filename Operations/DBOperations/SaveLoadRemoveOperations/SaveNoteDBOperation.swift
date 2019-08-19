import UIKit
import CoreData

class SaveNoteDBOperation: BaseDBOperation {
    
    init(note: Note, backgroundContext: NSManagedObjectContext) {
        super.init(context: backgroundContext)
        let uid = note.uid
        let isNoteExists: (String) -> (Bool) = { (someUID) in
            let request: NSFetchRequest<NoteMO> = NoteMO.fetchRequest()
            request.predicate = NSPredicate(format: "uid == %@", someUID)
            var result = false
            backgroundContext.performAndWait {
                do {
                    let noteMO = try backgroundContext.fetch(request).first
                    if noteMO != nil {
                        print("Rewriting old note...")
                        result = true
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            return result
        }
      
        if isNoteExists(uid) {
            for (index, noteFromCoreData) in notesFromCoreData.enumerated() {
                if noteFromCoreData.uid == uid {
                    notesFromCoreData.remove(at: index)
                    break
                }
            }
            removeNoteMO(backgroundContext: backgroundContext, noteUID: uid)
        }
        
        let noteMO = NoteMO.init(context: backgroundContext)
        noteMO.uid = note.uid
        noteMO.title = note.title
        noteMO.content = note.content
        noteMO.importance = note.importance.rawValue
        noteMO.destuctionDate = note.selfDestructionDate as NSDate?
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        note.noteColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        noteMO.noteColor = NSDictionary(dictionary: ["red": NSNumber.FloatLiteralType(red), "green": NSNumber.FloatLiteralType(green), "blue": NSNumber.FloatLiteralType(blue), "alpha": NSNumber.FloatLiteralType(alpha)])
        
        backgroundContext.performAndWait {
            do {
                try backgroundContext.save()
                notesFromCoreData.append(note)
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    override func main() {
        finish()
    }
}
