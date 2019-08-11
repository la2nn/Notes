import UIKit

enum SaveNotesBackendResult {
    case success
    case failure(Errors)
}

class SaveNotesBackendOperation: BaseBackendOperation {
    var result: SaveNotesBackendResult!
    var notesToUpload = [Note]()
    
    init(notes: [Note]) {
        self.notesToUpload = notes
        super.init()
    }
    
    override func main() {
        uploadNotes()
    }
    
    func uploadNotes()  {
        let urlComponentsString = (gistID.isEmpty ? "https://api.github.com/gists" : "https://api.github.com/gists/\(gistID)")
        let components = URLComponents(string: urlComponentsString)
        print("GIST ID: \(gistID)")
        guard let url = components?.url else { result = .failure(.unreachable); finish() ; return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = (gistID.isEmpty ? "POST" : "PATCH")
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        /* var resultText = "["
        for note in notesToUpload {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            note.noteColor.getRed(&r, green: &g, blue: &b, alpha: &a)
            
           resultText += #"{"uid": "\#(note.uid)", "title": "\#(note.title)", "content": "\#(note.content)", "noteColor": {"r": "\#(r)", "g": "\#(g)", "b": "\#(b)", "a": "\#(a)"}, "importance": "\#(note.importance.rawValue)", "selfDestructionDate": "\#(note.selfDestructionDate?.timeIntervalSinceReferenceDate ?? 0)"}, "#
        }
        resultText.removeLast()
        resultText += "]"
        print(resultText) */
      // for note in notesToUpload {
        
        guard let data = try? JSONEncoder().encode(notesToUpload) else {  result = .failure(.noNotes); finish() ; return }
        print(String(data: data, encoding: .utf8)!)
        
    
        let json: [String: Any] =
            ["description" : "ios-course-notes-db",
             "public" : false,
             "files" : ["ios-course-notes-db" : ["content": String(data: data, encoding: .utf8)!] ]]
        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200..<300: print("Success upload notes to server"); if gistID.isEmpty { self.getGistID() }
                default: print(response.statusCode) ; self.result = .failure(.unreachable) ; self.finish() ; return
                }
            }
            self.result = .success
            self.finish()
        }.resume()
        
    }
    
    func getGistID() {
        guard let url = URL(string: "https://api.github.com/users/\(username)/gists") else { result = .failure(.unreachable) ; self.finish() ; return }
        var request = URLRequest(url: url)
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { self.result = .failure(.unreachable); self.finish() ; return }
            guard let gists = try? JSONDecoder().decode([Gist].self, from: data) else
            { print("some error when parse gist") ; self.finish() ; return }
            
            for gist in gists {
                if gist.files["ios-course-notes-db"] != nil {
                    print("Notes file found; notes will be downloaded from the server.")
                    gistID = gist.id
                    break
                }
            }
            
         }.resume()
    }
    
}


