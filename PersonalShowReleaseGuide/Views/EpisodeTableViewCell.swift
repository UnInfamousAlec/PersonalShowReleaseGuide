//
//  EpisodeTableViewCell.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 6/14/18.
//  Copyright © 2018 UnInfamous Games. All rights reserved.
//

import UIKit

class EpisodeTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var episodeNumberLabel: UILabel!
    @IBOutlet weak var episodeNameLabel: UILabel!
    @IBOutlet weak var episodeAirDateLabel: UILabel!
    @IBOutlet weak var episodeOverviewLabel: UILabel!
    @IBOutlet weak var episodeOverviewButton: UIButton!
    
    
    // MARK: - Properties
    let dateFormat = "MMMM dd, YYYY"
    var episode: Episode? {
        didSet {
            updateEpisode()
        }
    }
    
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        //Remove data from cells
    }
    
    
    // MARK: - Methods
    func updateEpisode() {
        guard let episode = episode else { return }
        guard let episodeAirDate = episode.episodeAirDate else { return }
        guard let formattedAirDate = DateLogicController.shared.formatAirDate(withFormat: self.dateFormat, forDate: episodeAirDate) else { return }
        
        episodeNumberLabel.text = "Episode \(episode.episodeNumber)"
        episodeNameLabel.text = episode.episodeName
        episodeAirDateLabel.text = formattedAirDate // check to see it works
        episodeOverviewLabel.text = episode.episodeOverview
        episodeOverviewButton.isHidden = true
    }
    
    // MARK: - Actions
    @IBAction func episodeOverviewButtonTapped(_ sender: UIButton) {
//        episodeOverviewLabel.isHidden = false
//        episodeOverviewButton.isHidden = true
    }
    
}
