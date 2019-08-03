import Foundation

enum NetworkError {
    case unreachable
}

enum SaveNotesBackendResult {
    case success
    case failure(NetworkError)
}

class SaveNotesBackendOperation: BaseBackendOperation {
    var result: SaveNotesBackendResult?
    var notesToUpload = [Note]()
    
    init(notes: [Note]) {
        self.notesToUpload = notes
        super.init()
    }
    
    override func main() {
        result = .failure(.unreachable)
        
        switch result {
        case .some(.failure(.unreachable)): print("Невозможно сохранить заметки на сервер: Сервер не отвечает")
            
        case .none: print("result is nil")
        case .some(.success): print("Заметки успешно сохранены на сервер - \(notesToUpload.count) штук")
            
        }
        
        finish()
    }
}
