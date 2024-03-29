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
        
        guard let nc = self.navigationController as? NotesNavigationController else { return }
        self.notesNavigationController = nc
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(managedObjectContextDidSave(notification:)), name:
            NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
        
        tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
    
    @objc func managedObjectContextDidSave(notification: Notification) {
        self.notesNavigationController.backgroundContext.perform {
            self.notesNavigationController.backgroundContext.mergeChanges(fromContextDidSave: notification)
        }
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
        
        
        if let downloadedNotesFromServer = notesInCaseOfServerConntectionSuccess {
            notesInCaseOfServerConntectionSuccess = nil
            
            notesFromCoreData = downloadedNotesFromServer
            // Заменяем заметки на диске, в случае если есть доступ к серверу
            
            self.notes = downloadedNotesFromServer
            self.tableView.reloadData()
        } else {
            self.notes = notesFromCoreData
            self.tableView.reloadData()
        }
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
            note: notes[indexPath.row],
            backendQueue: notesNavigationController.backendQueue,
            dbQueue: notesNavigationController.dbQueue,
            backgroundContext: notesNavigationController.backgroundContext))
            
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            notesFromCoreData.remove(at: indexPath.row)
        }
    }
    
}
