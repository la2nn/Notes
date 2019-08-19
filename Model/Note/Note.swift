import UIKit

struct Note: Codable {
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
    
     init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uid = try container.decode(String.self, forKey: .uid)
        self.title = try container.decode(String.self, forKey: .title)
        self.content = try container.decode(String.self, forKey: .content)
        let noteColorComponents: [String : CGFloat] = try container.decode([String : CGFloat].self, forKey: .noteColor)
        self.noteColor = UIColor(red: noteColorComponents["red"] ?? 0, green: noteColorComponents["green"] ?? 0, blue: noteColorComponents["blue"] ?? 0, alpha: noteColorComponents["alpha"] ?? 1)
        self.importance = try container.decode(Importance.self, forKey: .importance)
        let date = try container.decode(Double.self, forKey: .selfDestructionDate)
        self.selfDestructionDate = Date(timeIntervalSinceReferenceDate: date)

    }
    
    enum CodingKeys: String, CodingKey {
        case uid
        case title
        case content
        case noteColor
        case importance
        case selfDestructionDate
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(title, forKey: .title)
        try container.encode(content, forKey: .content)
        try container.encode(Color(uiColor: noteColor), forKey: .noteColor)
        try container.encode(importance.rawValue, forKey: .importance)
        try container.encode(selfDestructionDate?.timeIntervalSinceReferenceDate ?? 0, forKey: .selfDestructionDate)
    }
}

enum Importance: String, Codable {
    case important = "important"
    case common = "common"
    case unimportant = "unimportant"
}

struct Color: Encodable {
    var red : CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0
    
    var uiColor : UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    init(uiColor : UIColor) {
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }
    
}
