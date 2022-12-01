//
//  NotesTableViewCell.swift
//  BreakingBadApp
//
//  Created by Hasan Esat Tozlu on 1.12.2022.
//

import UIKit

class NotesTableViewCell: UITableViewCell {

    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var note: EpisodeNotes? {
        didSet {
            configureComponents()
            
            noteLabel.text = note?.note
            episodeLabel.text = note?.seasonEpisode
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureComponents() {
        containerView.layer.cornerRadius        = 15
        containerView.layer.shadowColor         = UIColor.black.cgColor
        containerView.layer.shadowOffset        = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius        = 15
        containerView.layer.shadowOpacity       = 0.3
        containerView.layer.masksToBounds       = false
    }
    
}
