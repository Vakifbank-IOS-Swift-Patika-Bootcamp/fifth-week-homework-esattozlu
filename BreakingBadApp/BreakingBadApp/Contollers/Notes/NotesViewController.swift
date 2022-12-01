//
//  NotesViewController.swift
//  BreakingBadApp
//
//  Created by Hasan Esat Tozlu on 1.12.2022.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {

    @IBOutlet weak var notesTableView: UITableView!
    @IBOutlet weak var addNoteButton: UIButton!
    var addNoteView = AddNoteView()
    var seasonEpisodes = [[EpisodeModel]]()
    var notes = [EpisodeNotes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureComponents()
        configureTableView()
        getSeasonedEpisodes()
        getNotesFromCoreData()
    }
    
    func configureTableView() {
        notesTableView.delegate = self
        notesTableView.dataSource = self
        
        notesTableView.register(UINib(nibName: "NotesTableViewCell", bundle: nil), forCellReuseIdentifier: "NotesTableViewCell")
    }
    
    func getNotesFromCoreData() {
        notes = PersistanceManager.shared.getNotes()
        notesTableView.reloadData()
    }
    
    func getSeasonedEpisodes() {
        NetworkManager.getSeasonedEpisodes { seasonedEpisodes, error in
            self.addNoteButton.isEnabled = true
            if let seasonedEpisodes = seasonedEpisodes {
                self.seasonEpisodes = seasonedEpisodes
            }
        }
    }
    
    func configureComponents() {
        addNoteButton.isEnabled = false
        addNoteButton.layer.cornerRadius = 5
    }
    
    @IBAction func addNoteButtonClicked(_ sender: Any) {
        addNoteView.seasonEpisodeTextField.isEnabled = true
        addNoteView.isFromAddButton = true
        addNoteViewAsSubView()
    }
}

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notesTableView.dequeueReusableCell(withIdentifier: "NotesTableViewCell", for: indexPath) as? NotesTableViewCell
        let note = notes[indexPath.row]
        cell?.note = note
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedNote = notes[indexPath.row]
            PersistanceManager.shared.deleteNote(note: selectedNote)
            getNotesFromCoreData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addNoteView.seasonEpisodeTextField.text = notes[indexPath.row].seasonEpisode
        addNoteView.noteTextView.text = notes[indexPath.row].note
        addNoteView.seasonEpisodeTextField.isEnabled = false
        addNoteView.isFromAddButton = false
        addNoteView.selectedNote = notes[indexPath.row]
        addNoteViewAsSubView()
    }
    
    
    
    func addNoteViewAsSubView() {
        addNoteView.seasonEpisodes = self.seasonEpisodes
        addNoteView.frame = view.bounds
        addNoteView.saveButtonDelegate = self
        addNoteView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.addNoteView.alpha = 1
        }
        view.addSubview(addNoteView)
    }
}

// Remove subview with animation
extension NotesViewController: removeNoteViewDelegate {
    func removeSubview() {
        print("delegate works")
        getNotesFromCoreData()
        UIView.animate(withDuration: 0.3, animations: {self.addNoteView.alpha = 0.0}, completion: {(value: Bool) in
            self.addNoteView.removeFromSuperview()
        })
    }
}
