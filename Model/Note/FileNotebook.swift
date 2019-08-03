import UIKit

class FileNotebook {
    static let dir = "Notebooks"
    static let path = FileManager.default.urls(for: .applicationDirectory, in: .userDomainMask).first!

    private(set) var notes: [Note] = []
    
    public func add(_ note: Note) {
        for noteInArray in notes {
            if noteInArray.uid == note.uid {
                print("Rewriting old note...")
                remove(with: noteInArray.uid)
            }
        }
        
        notes.append(note)
        self.saveToFile()
    }
    
    public func remove(with uid: String) {
        let path = FileNotebook.path
        let dirurl = path.appendingPathComponent(FileNotebook.dir)
        var isDir: ObjCBool = false
        
        for (number, note) in notes.enumerated() {
            let filePath = dirurl.appendingPathComponent(note.uid)
            if note.uid == uid {
                notes.remove(at: number)
            }
            let path = dirurl.path + "/" + note.uid
            if FileManager.default.fileExists(atPath: path, isDirectory: &isDir) && !isDir.boolValue && note.uid == uid {
                print("REMOVING - \(note.title)")
                try? FileManager.default.removeItem(at: filePath)
                return
            }
        }
    }
    
    public func saveToFile() {
        let path = FileNotebook.path
        let dirurl = path.appendingPathComponent(FileNotebook.dir)
        var isDir: ObjCBool = false
        try? FileManager.default.createDirectory(at: dirurl, withIntermediateDirectories: true, attributes: nil)
        
        if FileManager.default.fileExists(atPath: dirurl.path, isDirectory: &isDir) && isDir.boolValue {
            for note in notes {
                let noteJSON = note.json
                let fileName = dirurl.appendingPathComponent("\(note.uid)").path
                do {
                    let data = try JSONSerialization.data(withJSONObject: noteJSON, options: [])
                    FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
                } catch {
                    print("ERROR")
                }
            }
        }
    }
    
    public func loadFromFile() {
        let path = FileNotebook.path
        let dirurl = path.appendingPathComponent(FileNotebook.dir)
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: dirurl.path, isDirectory: &isDir) && isDir.boolValue {
            do {
                print("Загрузка заметок с диска...")
                let folderContent = try FileManager.default.contentsOfDirectory(atPath: dirurl.path)
                let correctFolderContent = folderContent.filter { !$0.hasPrefix(".") }
                for noteFile in correctFolderContent {
                    guard let jsData = FileManager.default.contents(atPath: dirurl.appendingPathComponent(noteFile).path) else { continue }
                    let jsDict = try JSONSerialization.jsonObject(with: jsData, options: []) as! [String: Any]
                    if let noteFromFolder = Note.parse(json: jsDict) {
                        notes.append(noteFromFolder)
                    }
                }
            } catch {
                print("LOADING ERROR :c, DELETE HIDDEN FILES!!!")
            }
        }
    }
    
}

