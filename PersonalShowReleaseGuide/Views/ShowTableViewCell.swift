//
//  ShowTableViewCell.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 4/26/18.
//  Copyright © 2018 UnInfamous Games. All rights reserved.
//

import UIKit

class ShowTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var showTitleLabel: UILabel!
    @IBOutlet weak var showCurrentSeasonLabel: UILabel!
    @IBOutlet weak var showNextEpisodeLabel: UILabel!
    @IBOutlet weak var showTest: UILabel!
    @IBOutlet weak var showNextEpisodeAirDateLabel: UILabel!
    

    // MARK: - Properties
    var series: Series? {
        didSet {
            showAirYear()
            
        }
    }
    
    var currentSeason: Int? {
        didSet {
            showSeasonNumber()
        }
    }
    
    var currentEpisode: Int? {
        didSet {
            showEpisodeNumber()
        }
    }
    
    
    // MARK: - Methods
    func showAirYear() {
        
        guard let show = series else { return }
        var year = ""
        var showAirYear = ""
        
        for letter in show.pilotAirDate {
            if letter == "-" {
                break
            }
            year.append(letter)
        }
        
        if year.count > 0 {
            showAirYear = " (\(year))"
        } else {
            showAirYear = ""
        }
        
        self.showTitleLabel.text = "\(show.name)\(showAirYear)"
    }
    
    func showSeasonNumber() {

        guard let seasonNumber = self.currentSeason else { return }
        self.showCurrentSeasonLabel.text = "\(seasonNumber)"
    }
    
    func showEpisodeNumber() {
        
        guard let episodeNumber = self.currentEpisode else { return }
        self.showNextEpisodeLabel.text = "\(episodeNumber)"
    }
    
    func showNextEpisodeAirDate() {
        
        
    }
}
