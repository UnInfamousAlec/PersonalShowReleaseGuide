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
    
    
    // MARK: - Properties
    var episode: Episode? {
        didSet {
            updateEpisode()
        }
    }
    
    
    // MARK: - Methods
    func updateEpisode() {
        guard let episode = episode else { return }
        episodeNumberLabel.text = "Episode \(episode.episodeNumber)"
        episodeNameLabel.text = episode.episodeName
        episodeAirDateLabel.text = episode.episodeAirDate
        episodeOverviewLabel.text = episode.episodeOverview
    }
}
