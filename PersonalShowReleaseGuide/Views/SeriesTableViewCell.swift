//
//  SeriesTableViewCell.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 4/26/18.
//  Copyright © 2018 UnInfamous Games. All rights reserved.
//

import UIKit

class SeriesTableViewCell: UITableViewCell {
    
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
    
    var seasons: SeriesForSeason? {
        didSet {
            showSeasonNumber()
        }
    }
    
    var episodes: SeasonForEpisode? {
        didSet {
            showEpisodeNumber()
        }
    }
    
    
    // MARK: - Methods
    func showAirYear() {
        
        guard let series = series else { return }
        guard let pilotAirDate = series.pilotAirDate else { return }
        var year = ""
        var airYear = ""
        
        for letter in pilotAirDate {
            if letter == "-" {
                break
            }
            year.append(letter)
        }
        
        if year.count > 0 {
            airYear = " (\(year))"
        } else {
            airYear = ""
        }
        
        self.showTitleLabel.text = "\(series.name)\(airYear)"
    }
    
    func showSeasonNumber() {
        guard let seriesID = series?.ID else { return }
        let seasonNumber = DateLogicController.shared.findMostCurrentSeason(seriesID: seriesID)
        self.showCurrentSeasonLabel.text = "\(seasonNumber)"
    }
    
    func showEpisodeNumber() {
        guard let seriesID = series?.ID else { return }
        let episodeNumber = DateLogicController.shared.findMostCurrentEpisode(seriesID: seriesID)
        self.showNextEpisodeLabel.text = "\(episodeNumber)"
    }
    
    func showNextEpisodeAirDate() {
        guard let seriesID = series?.ID else { return }
//        let episodeAirDate = DateLogicController
        
    }
}
