import Foundation

class SaveNoteDBOperation: BaseDBOperation {
    
    init(note: Note, notebook: FileNotebook) {
        super.init(notebook: notebook)
        notebook.add(note)
    }
    
    override func main() {
        finish()
    }
}
