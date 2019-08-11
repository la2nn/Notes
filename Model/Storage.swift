//
//  Storage.swift
//  Notes
//
//  Created by Николай Спиридонов on 18/07/2019.
//  Copyright © 2019 nnick. All rights reserved.
//

import UIKit

struct tempNote {
    var note: Note?
    
    fileprivate init(note: Note? = nil) {
        self.note = note
    }
}

struct imageStorage {
    var images = [UIImage]()
    
    fileprivate init() {
        let imageNames = ["1.jpeg", "2.jpg","3.jpg", "4.jpg", "5.jpg", "6.jpg", "7.jpeg","8.jpeg", "9.jpg", "10.jpeg", "11.jpg", "12.jpg", "13.jpeg", "14.jpeg", "15.jpg", "16.png"]
        imageNames.forEach { self.images.append(UIImage(named: $0)!) }
    }
}

var noteInStorage = tempNote()                        // contains only one note ; it needs for NoteEditorViewController
var imagesInStorage = imageStorage()                  // contains all photos
var notesInCaseOfServerConntectionSuccess: [Note]?    // Contains DOWNLOADED FROM SERVER NOTES

var gistID = ""
var token = "00d3f545f1796063b80ace75bdae916830563e0b"
var username = "la2nn"
