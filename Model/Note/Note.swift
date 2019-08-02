import UIKit

struct Note {
    let uid: String
    let title: String
    let content: String
    let noteColor: UIColor
    let importance: Importance
    let selfDestructionDate: Date?
    
    init(uid: String? = nil, title: String, content: String, noteColor: UIColor = .white, importance: Importance, selfDestructionDate: Date? = nil) {
        self.uid = uid ?? UUID().uuidString
        self.noteColor = noteColor
        self.title = title
        self.content = content
        self.importance = importance
        self.selfDestructionDate = selfDestructionDate
    }
}

enum Importance: String {
    case important = "important"
    case common = "common"
    case unimportant = "unimportant"
}
