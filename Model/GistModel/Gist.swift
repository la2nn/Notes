//
//  GistDownload.swift
//  Notes
//
//  Created by Николай Спиридонов on 10/08/2019.
//  Copyright © 2019 nnick. All rights reserved.
//

import Foundation


struct Gist: Decodable {
    let files: [String: GistFile]
    let id: String
    
}

struct GistFile: Decodable {
    let raw_url: String
}
