//
//  LoadNotesBackendOperation.swift
//  Notes
//
//  Created by Николай Спиридонов on 03/08/2019.
//  Copyright © 2019 nnick. All rights reserved.
//

import Foundation

enum LoadNotesBackendResult {
    case success([Note])
    case failure(NetworkError)
}

class LoadNotesBackendOperation: BaseBackendOperation {
    var result: LoadNotesBackendResult?
   // var downloadedNotes: [Note]?
    
    init(notes: [Note]?) {
        super.init()
        guard let notesFromDB = notes else { result = .failure(.unreachable) ; return }
        result = .success(notesFromDB)
        // self.downloadedNotes = notesFromDB
        // Реализация будет здесь
    }
    
    override func main() {
   //     result = .failure(.unreachable)
        
        switch result {
        case .some(.failure(.unreachable)): print("Невозможно загрузить заметки: Сервер не отвечает")
            
        case .none: print("Result is nil")
        case .some(.success): print("Заметки успешно загружены с сервера")
            
        }
        
        finish()
    }
}
