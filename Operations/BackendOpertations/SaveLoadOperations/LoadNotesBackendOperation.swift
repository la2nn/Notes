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
    case failure(Errors)
}

class LoadNotesBackendOperation: BaseBackendOperation {
    var result: LoadNotesBackendResult!
    var downloadedNotes = [Note]()
    
    override func main() {
        gistParse()
    }
    
    func gistParse() {
        guard let url = URL(string: "https://api.github.com/gists") else { result = .failure(.unreachable) ; self.finish() ; return }
        var request = URLRequest(url: url)
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")

        var success = false
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { self.result = .failure(.unreachable); self.finish() ; return }
            guard let gists = try? JSONDecoder().decode([Gist].self, from: data) else { print("Some error when parse gistFile"); self.result = .failure(.unreachable) ; self.finish() ; return }
            for gist in gists {
                if gist.files["ios-course-notes-db"] != nil {
                    success = true
                    print("Notes file found; notes will be downloaded from the server.")
                    gistID = gist.id
                    print("GistID: \(gistID)")
                    self.loadNoteFromGist(rawUrl: gist.files["ios-course-notes-db"]!.raw_url)
                    break
                }
            }
            
            if success == false {
                self.result = .failure(.fileNotExist)
                self.finish()
            }
            
        }.resume()
    }
    
    func loadNoteFromGist(rawUrl: String) {
        guard let url = URL(string: rawUrl) else { result = .failure(.unreachable); self.finish() ; return }
        var request = URLRequest(url: url)
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            guard let notes = try? JSONDecoder().decode([Note].self, from: data) else { print("Some error when parse file from gist"); self.result = .failure(.noNotes); self.finish() ; return }
        
            self.downloadedNotes = notes
            
            if self.downloadedNotes.isEmpty {
                self.result = .failure(.noNotes)
            } else {
                print("Amount of downloaded notes: \(self.downloadedNotes.count)")
                self.result = .success(self.downloadedNotes)
            }
            
            self.finish()

        }.resume()

    }
    
}
