//
//  EpisodesViewController.swift
//  BreakingBadApp
//
//  Created by Hasan Esat Tozlu on 22.11.2022.
//

import UIKit

class EpisodesViewController: UIViewController {

    @IBOutlet weak var episodesTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var seasonEpisodes = [[EpisodeModel]]()
    let detailView = EpisodeDetailVew()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        episodesTableView.delegate = self
        episodesTableView.dataSource = self
        episodesTableView.register(UINib(nibName: "EpisodesTableViewCell", bundle: nil), forCellReuseIdentifier: "episodeCell")
        getEpisodes()
    }

    func getEpisodes() {
        activityIndicator.startAnimating()
        NetworkManager.getSeasonedEpisodes { seasonedEpisodes, error in
            self.activityIndicator.stopAnimating()
            if let seasonedEpisodes = seasonedEpisodes {
                self.seasonEpisodes = seasonedEpisodes
            } else {
                if let error = error {
                    self.alert(title: "Alert", message: error.localizedDescription)
                }
            }
            DispatchQueue.main.async {
                self.episodesTableView.reloadData()
            }
        }
    }
}

extension EpisodesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        seasonEpisodes.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        seasonEpisodes[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = episodesTableView.dequeueReusableCell(withIdentifier: "episodeCell", for: indexPath) as? EpisodesTableViewCell
        cell?.episode = seasonEpisodes[indexPath.section][indexPath.row]
        return cell ?? UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailView.frame = view.bounds
        detailView.closeButtonDelegate = self
        detailView.characters.removeAll()
        detailView.characterNames = seasonEpisodes[indexPath.section][indexPath.row].characters
        detailView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.detailView.alpha = 1
        }
        view.addSubview(detailView)
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Season: \(section+1)"
    }
    
    // Tableview section headers configuration
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let view = view as! UITableViewHeaderFooterView
        var content = view.defaultContentConfiguration()
        content.text = "Season: \(section+1)"
        content.textProperties.color = .white
        content.textProperties.font = .boldSystemFont(ofSize: 20)
        view.contentConfiguration = content
        view.contentView.backgroundColor = .systemGray
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}


// Remove subview with animation
extension EpisodesViewController: subviewRemoveDelegate {
    func removeSubview() {
        print("delegate works")
        UIView.animate(withDuration: 0.3, animations: {self.detailView.alpha = 0.0}, completion: {(value: Bool) in
            self.detailView.removeFromSuperview()
        })
    }
}
