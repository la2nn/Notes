//
//  ViewController.swift
//  Notes
//
//  Created by Николай Спиридонов on 30/06/2019.
//  Copyright © 2019 nnick. All rights reserved.
//

import UIKit

class NoteEditorViewController: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var contentView: UITextView!

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerHeight: NSLayoutConstraint!
    @IBOutlet weak var selfDestructionSwitchOutlet: UISwitch!
    
    @IBOutlet weak var whiteColorView: ColorMark!
    @IBOutlet weak var redColorView: ColorMark!
    @IBOutlet weak var greenColorView: ColorMark!
    @IBOutlet weak var colorPickerView: ColorMark!
    @IBOutlet var colorUIViews: [ColorMark]!
    @IBOutlet weak var importanceControl: UISegmentedControl!
    @IBOutlet weak var saveNoteButton: UIButton!
    
    var transferedNote = noteInStorage.note
    var transferedNoteUID = noteInStorage.note?.uid
    
    var colorPickerVC: ColorPickerViewController!
    var selectedColorView: ColorMark?
    var colorPickerViewTouchedAtLeastOneTime = false
    var chosenColor: UIColor?
    
    func drawColorMark(selectedView: ColorMark) {
        // Removing old marks
        colorUIViews.forEach { $0.shouldDrawMark = false ; $0.draw($0.frame) }
        
        // Drawing new mark
        selectedColorView = selectedView
        selectedColorView?.shouldDrawMark = true
        selectedColorView?.draw(selectedColorView!.frame)
    }
    
    @objc func handleTap(tap: UITapGestureRecognizer) {
        let tappedView = self.view.hitTest(tap.location(in: self.view), with: nil)
        guard let tappedViewUnwarpped = tappedView else { return }
        
        var selectedView: ColorMark!
        switch tappedViewUnwarpped {
            case whiteColorView: selectedView = whiteColorView
            case redColorView: selectedView = redColorView
            case greenColorView: selectedView = greenColorView
            case colorPickerView: selectedView = colorPickerView
            default: break
        }
        drawColorMark(selectedView: selectedView)
       
        // Change bool value if colorPickerView do not have it own color (not `palette` image)
        if (selectedColorView ?? colorPickerView) == colorPickerView && !colorPickerViewTouchedAtLeastOneTime {
            colorPickerViewTouchedAtLeastOneTime = true
            presentColorPickerVC()
        }
    }
    
    @objc func handleLongPress(press: UILongPressGestureRecognizer) {
        presentColorPickerVC()
        if !colorPickerViewTouchedAtLeastOneTime { colorPickerViewTouchedAtLeastOneTime = true }
    }
    
    func presentColorPickerVC() {
            colorPickerVC = ColorPickerViewController()
            colorPickerVC!.delegate = self
            present(colorPickerVC!, animated: true, completion: nil)
    }
    
    @IBAction func tapSomewhereInScroll(_ sender: UITapGestureRecognizer) {
       view.endEditing(true)
    }
    
    @IBAction func selfDestructionSwitch(_ sender: UISwitch) {
        if sender.isOn {
            datePickerHeight.constant = 210
            datePicker.isHidden = false
        } else {
            datePickerHeight.constant = 0
            datePicker.isHidden = true
        }
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
         }
    }
    
    @IBAction func saveNotePressed(_ sender: Any) {
        var color: UIColor = .green
        colorUIViews.forEach { if $0.shouldDrawMark {  color = $0.backgroundColor ?? .green } }
        
        guard let navController = navigationController as? NotesNavigationController else { return }
        
        var importance: Importance = .common
        switch importanceControl.selectedSegmentIndex {
        case 0: importance = .unimportant
        case 1: importance = .common
        case 2: importance = .important
        default: break
        }
        
        let note = Note(uid: transferedNoteUID ?? nil, title: titleField.text ?? "", content: contentView.text ?? "", noteColor: color, importance: importance, selfDestructionDate: selfDestructionSwitchOutlet.isOn ? datePicker.date : nil)
        
        navController.saveNotesQueue.addOperation(SaveNoteOperation(note: note, notebook: navController.notebook, backendQueue: navController.backendQueue, dbQueue: navController.dbQueue))
        
        // Delete old data
        transferedNoteUID = nil
        
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date(timeInterval: 60 * 60 * 24 , since: Date())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setting()
    }
    
    func setting() {
        // Add delegates
        titleField.delegate = self
        contentView.delegate = self
        
        // Add tap gesture recognizer for color views
        colorUIViews.forEach {
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(tap:)))
            $0.addGestureRecognizer(tap)
        }
        
        // Add long press gesture recognizer for colorPickerView
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(press:)))
        colorPickerView.addGestureRecognizer(longTap)
        
        // Laying image on UIView with resizing
        if chosenColor == nil {
            let rgbImage = UIImage(named: "rgb-colors.jpg")!
            let rgbImageResized = rgbImage.scaled(with: 0.15)
            colorPickerView.backgroundColor = UIColor(patternImage: rgbImageResized)
        } else {
            colorPickerView.backgroundColor = chosenColor
        }
        
        // Make borders for UITextView (contentView) and colorViews
        contentView.layer.borderWidth = 2
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = UIColor.black.cgColor
        colorUIViews.forEach { $0.layer.borderColor = UIColor.black.cgColor ;
                               $0.layer.borderWidth = 2 ;
                               $0.layer.cornerRadius = $0.frame.width / 5 }
        whiteColorView.backgroundColor = .white
        redColorView.backgroundColor = .red
        greenColorView.backgroundColor = .green
        
        // In case of editing old Note
        if let note = transferedNote {
            titleField.text = note.title
            contentView.text = note.content
            print(note.importance.rawValue)
            switch note.importance {
                case .unimportant: importanceControl.selectedSegmentIndex = 0
                case .common: importanceControl.selectedSegmentIndex = 1
                case .important: importanceControl.selectedSegmentIndex = 2
            }
            
            switch note.noteColor {
                case .white: selectedColorView = whiteColorView
                case .green: selectedColorView = greenColorView
                case .red: selectedColorView = redColorView
                default: selectedColorView = colorPickerView; colorPickerView.backgroundColor = note.noteColor
            }
            
            if let destructionDate = note.selfDestructionDate {
                if destructionDate.timeIntervalSinceReferenceDate > 0 {
                    selfDestructionSwitchOutlet.isOn = true
                    datePicker.date = destructionDate
                    selfDestructionSwitch(selfDestructionSwitchOutlet)
                }
            }
            
            // Delete old data
            noteInStorage.note = nil
            transferedNote = nil
        }
        
        // Drawing mark
        if selectedColorView == nil {
            selectedColorView = whiteColorView
            selectedColorView?.shouldDrawMark = true
        }
        drawColorMark(selectedView: selectedColorView!)
        
        // Text in content "like" placeholder
        if contentView.text.isEmpty {
            contentView.text = "Write something here..."
            contentView.textColor = .darkGray
        }
        
        // Button some changes
        saveNoteButton.layer.cornerRadius = saveNoteButton.frame.width / 8
    }
    
}

extension UIImage {
    func scaled(with scale: CGFloat) -> UIImage {
        // Size has to be integer, otherwise it could get white lines
        let size = CGSize(width: floor(self.size.width * scale), height: floor(self.size.height * scale))
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UIColor {
    static var counter = 0
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let multiplier = CGFloat(255.999)
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        guard red >= 0, green >= 0, blue >= 0 else {
            return "#000000"
        }
    
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
    }
}

extension NoteEditorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        contentView.becomeFirstResponder()
        return true
    }
}

 extension NoteEditorViewController: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        contentView.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .darkGray {
            textView.textColor = .black
            textView.text = ""
        }
    }
}

extension NoteEditorViewController: ColorPickerViewControllerDelegate {
    func getColor(pickedColor: UIColor) {
        chosenColor = pickedColor
        
        // Drawing mark on colorPickerView
        selectedColorView = colorPickerView
        drawColorMark(selectedView: colorPickerView)
        colorPickerVC = nil
    }
}

