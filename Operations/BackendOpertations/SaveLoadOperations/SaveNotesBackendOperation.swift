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
        guard let url = components?.url else { result = .failure(.unreachable); finish() ; return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = (gistID.isEmpty ? "POST" : "PATCH")
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let data = try? JSONEncoder().encode(notesToUpload) else {  result = .failure(.noNotes); finish() ; return }
        print(String(data: data, encoding: .utf8)!)
        
        let json: [String: Any] =
            ["description" : "ios-course-notes-db",
             "public" : false,
             "files" : ["ios-course-notes-db" : ["content": String(data: data, encoding: .utf8)!] ]]
        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if gistID.isEmpty {
                print("Seems that there no ios-course-notes-db file... Creating...")
                if let dataNotNil = data {
                    do {
                        let createdGist = try JSONDecoder().decode(Gist.self, from: dataNotNil)
                        gistID = createdGist.id
                        print("GistID: \(gistID)")
                    } catch {
                        print("Error... Cannot get id from new gist file.")
                    }
                }
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200..<300: print("Success upload notes to server")
                default: print(response.statusCode) ; self.result = .failure(.unreachable) ; self.finish() ; return
                }
            }
            
            self.result = .success
            self.finish()
        }.resume()
        
    }
    
}


