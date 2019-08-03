//
//  NotesTableViewController.swift
//  Notes
//
//  Created by Николай Спиридонов on 18/07/2019.
//  Copyright © 2019 nnick. All rights reserved.
//

import UIKit

class NotesTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let reuseIdentifier = "note cell"
    var notesNavigationController: NotesNavigationController!
    var isEditingModeEnabled = false
    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isEditingModeEnabled = false
        tableView.setEditing(isEditingModeEnabled, animated: false)
        settingLeftNavigationBarItem()
    }
    
    func setting() {
        settingLeftNavigationBarItem()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showEditorVC))
    }
    
    func settingLeftNavigationBarItem() {
        if isEditingModeEnabled {
            let leftItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editPressed))
            leftItem.tintColor = .red
            navigationItem.leftBarButtonItem = leftItem
        } else {
            let leftItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPressed))
            navigationItem.leftBarButtonItem = leftItem
        }
    }
    
    @objc func editPressed() {
        isEditingModeEnabled = !isEditingModeEnabled
        settingLeftNavigationBarItem()
        tableView.setEditing(isEditingModeEnabled, animated: true)
    }
    
    @objc func showEditorVC() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "NoteEditorViewController") as! NoteEditorViewController
        navigationController?.pushViewController(resultViewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let nc = navigationController as? NotesNavigationController else { return }
        notesNavigationController = nc
        
        if let downloadedNotesFromServer = notesInCaseOfServerConntectionSuccess {
            for note in notesNavigationController.notebook.notes {
                notesNavigationController.notebook.remove(with: note.uid)
                // Удаляем заметки на диске, в случае если есть доступ к серверу
            }
            for note in downloadedNotesFromServer {
                notesNavigationController.notebook.add(note)
                // Добавляем заметки с сервера, в случае если к нему есть доступ
            }
        }
        
        notes = notesNavigationController.notebook.notes
        
        tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tableView.reloadData()
    }
    
}

extension NotesTableViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NoteTableViewCell
        cell.titleLabel.text = notes[indexPath.row].title
        cell.contentLabel.text = notes[indexPath.row].content
        cell.noteColor.backgroundColor = notes[indexPath.row].noteColor
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Notes"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        noteInStorage.note = notes[indexPath.row]
        showEditorVC()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notesNavigationController.removeNoteQueue.qualityOfService = .userInteractive
            
            notesNavigationController.removeNoteQueue.addOperation(RemoveNoteOperation(
            noteUID: notesNavigationController.notebook.notes[indexPath.row].uid,
            notebook: notesNavigationController.notebook,
            backendQueue: notesNavigationController.backendQueue,
            dbQueue: notesNavigationController.dbQueue))
            
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
