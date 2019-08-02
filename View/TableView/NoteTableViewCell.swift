//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by Николай Спиридонов on 18/07/2019.
//  Copyright © 2019 nnick. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var noteColor: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        noteColor.layer.cornerRadius = noteColor.frame.width / 5
        noteColor.layer.borderWidth = 1
        noteColor.layer.borderColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = noteColor.backgroundColor
        super.setSelected(selected, animated: animated)
        
        if selected {
            noteColor.backgroundColor = color
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = noteColor.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            noteColor.backgroundColor = color
        }
    }
    
}
