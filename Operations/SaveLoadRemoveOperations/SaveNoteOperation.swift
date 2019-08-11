import Foundation

class SaveNoteOperation: AsyncOperation {

    private let saveToDb: SaveNoteDBOperation
    private var saveToBackend: SaveNotesBackendOperation

    init(note: Note,
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        
        saveToDb = SaveNoteDBOperation(note: note, notebook: notebook)
        saveToBackend = SaveNotesBackendOperation(notes: notebook.notes)
        super.init()
        
        saveToDb.completionBlock = {
            backendQueue.addOperation(self.saveToBackend)
        }
        
       // addDependency(saveToBackend)
        saveToBackend.addDependency(saveToDb)
        
        //self.addDependency(saveToDb)
        dbQueue.addOperation(saveToDb)
    }
    
    override func main() {
        finish()
    }
}
