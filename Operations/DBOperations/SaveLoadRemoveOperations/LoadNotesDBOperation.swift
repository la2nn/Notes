//
//  LoadNotesDBOperation.swift
//  Notes
//
//  Created by Николай Спиридонов on 03/08/2019.
//  Copyright © 2019 nnick. All rights reserved.
//

import Foundation

class LoadNotesDBOperation: BaseDBOperation {
    
    override func main() {
        notebook.loadFromFile()
        finish()
    }
}
