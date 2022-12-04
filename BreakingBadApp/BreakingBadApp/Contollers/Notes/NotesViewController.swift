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
    var addNoteVC = AddNoteViewController()
    var seasonEpisodes = [[EpisodeModel]]()
    var notes = [EpisodeNotes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureComponents()
        configureTableView()
        getSeasonedEpisodes()
        getNotesFromCoreData()
        addNoteVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addNoteVC") as! AddNoteViewController
    }
    
    func configureTableView() {
        notesTableView.delegate = self
        notesTableView.dataSource = self
        
        notesTableView.register(UINib(nibName: "NotesTableViewCell", bundle: nil), forCellReuseIdentifier: "NotesTableViewCell")
    }
    
    func getNotesFromCoreData() {
        notes = PersistanceManager.shared.getNotes()
        notes.sort{ $0.seasonEpisode! < $1.seasonEpisode! }
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
        addNoteVC.selectedNote = nil
        addNoteVC.episodeCheckerDelegate = self
        addNoteVC.saveButtonDelegate = self
        addNoteVC.isFromAddButton = true
        addNoteVC.seasonEpisodes = self.seasonEpisodes
        presentAddNoteVC()
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
        addNoteVC.episodeCheckerDelegate = self
        addNoteVC.saveButtonDelegate = self
        addNoteVC.isFromAddButton = false
        addNoteVC.selectedNote = notes[indexPath.row]
        addNoteVC.seasonEpisodes = self.seasonEpisodes
        presentAddNoteVC()
    }
    
    func presentAddNoteVC() {
        addNoteVC.modalPresentationStyle  = .overFullScreen
        addNoteVC.modalTransitionStyle    = .crossDissolve
        self.present(addNoteVC, animated: true)
    }
    
}

// Remove subview with animation
extension NotesViewController: saveButtonDelegate {
    func noteSaved() {
        print("delegate works")
        getNotesFromCoreData()
    }
}

extension NotesViewController: addedEpisodeCheckerDelegate {
    func addedEpisodeCheck(episode: String) -> EpisodeNotes? {
        var foundEpisode: EpisodeNotes?
        notes.forEach{
            if $0.seasonEpisode == episode {
                foundEpisode = $0
            }
        }
        return foundEpisode
    }
}
