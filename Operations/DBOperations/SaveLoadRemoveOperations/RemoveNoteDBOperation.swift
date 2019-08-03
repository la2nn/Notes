//
//  RemoveNoteDBOperation.swift
//  Notes
//
//  Created by Николай Спиридонов on 03/08/2019.
//  Copyright © 2019 nnick. All rights reserved.
//

import Foundation

class RemoveNoteDBOperation: BaseDBOperation {
    var noteUID: String
    
    init(notebook: FileNotebook, noteUID: String) {
        self.noteUID = noteUID
        super.init(notebook: notebook)
    }
    
    override func main() {
        notebook.remove(with: noteUID)
    }
}
