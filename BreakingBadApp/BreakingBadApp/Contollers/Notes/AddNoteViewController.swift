//
//  AddNoteViewController.swift
//  BreakingBadApp
//
//  Created by Hasan Esat Tozlu on 4.12.2022.
//

import UIKit

protocol saveButtonDelegate: AnyObject {
    func noteSaved()
}

protocol addedEpisodeCheckerDelegate: AnyObject {
    func addedEpisodeCheck(episode: String) -> EpisodeNotes?
}

class AddNoteViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var seasonEpisodeTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    var seasonEpisodePickerView = UIPickerView()
    weak var saveButtonDelegate: saveButtonDelegate?
    weak var episodeCheckerDelegate: addedEpisodeCheckerDelegate?
    var seasonEpisodes: [[EpisodeModel]]?
    var isFromAddButton = true
    var selectedNote: EpisodeNotes?
    var noteFromCoreData: EpisodeNotes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        configureComponents()
        configurePickers()
        addDoneButtonOnKeyboard()
        seasonEpisodeTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        seasonEpisodeTextField.text = ""
        noteTextView.text = ""
        seasonEpisodeTextField.isEnabled = true
        if let selectedNote = selectedNote {
            seasonEpisodeTextField.text = selectedNote.seasonEpisode
            noteTextView.text = selectedNote.note
            seasonEpisodeTextField.isEnabled = false
        }
    }
    
    func configurePickers() {
        seasonEpisodePickerView.delegate = self
        seasonEpisodePickerView.dataSource = self
    }
    
    func configureComponents() {
        containerView.layer.cornerRadius        = 15
        containerView.layer.shadowColor         = UIColor.black.cgColor
        containerView.layer.shadowOffset        = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius        = 15
        containerView.layer.shadowOpacity       = 0.3
        containerView.layer.masksToBounds       = false
        
        noteTextView.layer.cornerRadius        = 15
        noteTextView.layer.shadowColor         = UIColor.black.cgColor
        noteTextView.layer.shadowOffset        = CGSize(width: 0, height: 0)
        noteTextView.layer.shadowRadius        = 15
        noteTextView.layer.shadowOpacity       = 0.3
        noteTextView.layer.masksToBounds       = false
        
        seasonEpisodeTextField.layer.cornerRadius        = 15
        seasonEpisodeTextField.layer.shadowColor         = UIColor.black.cgColor
        seasonEpisodeTextField.layer.shadowOffset        = CGSize(width: 0, height: 0)
        seasonEpisodeTextField.layer.shadowRadius        = 15
        seasonEpisodeTextField.layer.shadowOpacity       = 0.3
        seasonEpisodeTextField.layer.masksToBounds       = false
        
        seasonEpisodeTextField.inputView = seasonEpisodePickerView
        seasonEpisodeTextField.tintColor = .clear
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        if isFromAddButton {
            if let seasonEpisode = seasonEpisodeTextField.text, seasonEpisode != "",
               let note = noteTextView.text, note != "" {
                PersistanceManager.shared.saveNote(seasonEpisode: seasonEpisode, note: note)
                saveButtonDelegate?.noteSaved()
                dismiss(animated: true)
            } else {
                alert(title: "Alert", message: "Please select an episode and enter a note.")
            }
        } else {
            guard let selectedNote = selectedNote else { return }
            if let seasonEpisode = seasonEpisodeTextField.text, seasonEpisode != "",
               let note = noteTextView.text, note != "" {
                selectedNote.note = note
                selectedNote.seasonEpisode = seasonEpisode
                PersistanceManager.shared.updateNote(note: selectedNote)
                saveButtonDelegate?.noteSaved()
                dismiss(animated: true)
            } else {
                alert(title: "Alert", message: "Please select an episode and enter a note.")
            }
        }
    }
    
    func episodeCheck(episode: String) -> EpisodeNotes? {
        let foundEpisode = episodeCheckerDelegate?.addedEpisodeCheck(episode: episode)
        return foundEpisode
    }
    
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))

        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)

        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.noteTextView.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction() {
        self.noteTextView.resignFirstResponder()
    }
}

extension AddNoteViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return seasonEpisodes?.count ?? 0
        } else {
            let selectedSeason = pickerView.selectedRow(inComponent: 0)
            return seasonEpisodes?[selectedSeason].count ?? 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "Season \(row+1)"
        } else {
            let selectedSeason = pickerView.selectedRow(inComponent: 0)
            if let seasonEpisodes = seasonEpisodes {
                return "Episode \(seasonEpisodes[selectedSeason][row].episode)"
            } else {
                return ""
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            let selectedEpisode = pickerView.selectedRow(inComponent: 1)
            pickerView.reloadComponent(1)
            seasonEpisodeTextField.text = "Season \(row+1), Episode: \(selectedEpisode+1)"
        } else {
            let selectedSeason = pickerView.selectedRow(inComponent: 0)
            seasonEpisodeTextField.text = "Season \(selectedSeason+1), Episode: \(row+1)"
        }
    }
}

extension AddNoteViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "" {
            seasonEpisodePickerView.selectRow(0, inComponent: 0, animated: false)
            seasonEpisodePickerView.selectRow(0, inComponent: 1, animated: false)
        }
        
        seasonEpisodeTextField.text = "Season \(seasonEpisodePickerView.selectedRow(inComponent: 0)+1), Episode: \(seasonEpisodePickerView.selectedRow(inComponent: 1)+1)"
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let foundEpisode = episodeCheck(episode: textField.text ?? "") {
            noteTextView.text = foundEpisode.note
            selectedNote = foundEpisode
            isFromAddButton = false
        } else {
            noteTextView.text = ""
            isFromAddButton = true
        }
    }
}

