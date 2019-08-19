import Foundation
import CoreData

class SaveNoteOperation: AsyncOperation {

    private let saveToDb: SaveNoteDBOperation
    private var saveToBackend: SaveNotesBackendOperation

    init(note: Note,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue,
         backgroundContext: NSManagedObjectContext) {
        
        saveToDb = SaveNoteDBOperation(note: note, backgroundContext: backgroundContext)
        saveToBackend = SaveNotesBackendOperation(notes: notesFromCoreData)
        super.init()
        
        saveToDb.completionBlock = {
            backendQueue.addOperation(self.saveToBackend)
        }
        
        saveToBackend.addDependency(saveToDb)
        dbQueue.addOperation(saveToDb)
    }
    
    override func main() {
        finish()
    }
}
