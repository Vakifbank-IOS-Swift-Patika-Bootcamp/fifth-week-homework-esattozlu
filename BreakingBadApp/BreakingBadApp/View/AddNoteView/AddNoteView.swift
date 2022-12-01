//
//  AddNoteView.swift
//  BreakingBadApp
//
//  Created by Hasan Esat Tozlu on 1.12.2022.
//

import UIKit

protocol removeNoteViewDelegate: AnyObject {
    func removeSubview()
}

class AddNoteView: UIView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var seasonEpisodeTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    var seasonEpisodePickerView = UIPickerView()
    weak var saveButtonDelegate: removeNoteViewDelegate?
    var seasonEpisodes: [[EpisodeModel]]?
    var isFromAddButton = true
    var selectedNote: EpisodeNotes?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func customInit() {
        let nib = UINib(nibName: "AddNoteView", bundle: nil)
        if let view = nib.instantiate(withOwner: self).first as? UIView {
            addSubview(view)
            view.frame = self.bounds
            view.backgroundColor = .black
            view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        }
        
        hideKeyboardWhenTappedAround()
        configureComponents()
        configurePickers()
        seasonEpisodeTextField.delegate = self
    }
    
    func configurePickers() {
        seasonEpisodePickerView.delegate = self
        seasonEpisodePickerView.dataSource = self
        
        seasonEpisodePickerView.selectRow(0, inComponent: 0, animated: false)
        seasonEpisodePickerView.selectRow(0, inComponent: 1, animated: false)
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
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        if isFromAddButton {
            if let seasonEpisode = seasonEpisodeTextField.text, seasonEpisode != "",
               let note = noteTextView.text, note != "" {
                PersistanceManager.shared.saveNote(seasonEpisode: seasonEpisode, note: note)
                saveButtonDelegate?.removeSubview()
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
                saveButtonDelegate?.removeSubview()
            } else {
                alert(title: "Alert", message: "Please select an episode and enter a note.")
            }
        }
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        saveButtonDelegate?.removeSubview()
    }
    
    
}

extension AddNoteView: UIPickerViewDelegate, UIPickerViewDataSource {
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

extension AddNoteView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        seasonEpisodeTextField.text = "Season \(seasonEpisodePickerView.selectedRow(inComponent: 0)+1), Episode: \(seasonEpisodePickerView.selectedRow(inComponent: 1)+1)"
    }
}
