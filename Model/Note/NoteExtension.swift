import UIKit

extension Note {
    var json: [String: Any] {
        var dict: [String: Any] = ["uid": uid,
                                   "title": title,
                                   "content": content]
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        noteColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        dict["noteColor"] = ["r": red, "g": green, "b": blue, "a": alpha]
        dict["importance"] = importance.rawValue
        
        if let selfDestructionDateToParse = selfDestructionDate {
            dict["selfDestructionDate"] = Double(selfDestructionDateToParse.timeIntervalSinceReferenceDate)
        }
        
        return dict
    }
    
    static func parse(json: [String: Any]) -> Note? {
        
        guard let title = json["title"] as? String, let content = json["content"] as? String, let uid = json["uid"] as? String else {
            return nil
        }
        
        var noteColor: UIColor
        if let noteColorParsed = json["noteColor"] as? [String: CGFloat] {
            noteColor = UIColor(red: noteColorParsed["r"] ?? 1.0,
                                green: noteColorParsed["g"] ?? 1.0,
                                blue: noteColorParsed["b"] ?? 1.0,
                                alpha: noteColorParsed["a"] ?? 1.0)
        } else {
            noteColor = .white
        }
        
        let importanceParsed = json["importance"] as? String
        var importance: Importance

        switch importanceParsed {
        case "important":   importance = .important
        case "unimportant": importance = .unimportant
        default:            importance = .common
        }
        
        var selfDestructionDate: Date?
        if let selfDestructionDateParsed = json["selfDestructionDate"] as? Double {
            selfDestructionDate = Date(timeIntervalSinceReferenceDate: selfDestructionDateParsed)
        }
        
        return Note(uid: uid,
                    title: title,
                    content: content,
                    noteColor: noteColor,
                    importance: importance,
                    selfDestructionDate: selfDestructionDate)
    }
}
