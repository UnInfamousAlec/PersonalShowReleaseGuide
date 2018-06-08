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
            showEpisode()
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
            airYear = "(\(year))"
        } else {
            airYear = "(Unknown)"
        }
        
        self.showTitleLabel.text = "\(series.name) \(airYear)"
    }
    
    func showSeasonNumber() {
        guard let seriesID = series?.ID else { return }
        let seasonNumber = DateLogicController.shared.findMostCurrentSeason(seriesID: seriesID)
        self.showCurrentSeasonLabel.text = String(seasonNumber)
    }
    
    func showEpisode() {
        guard let seriesID = series?.ID else { return }
        let episode = DateLogicController.shared.findMostCurrentEpisode(seriesID: seriesID)
        guard let episodeNumber = episode.keys.first else { return }
        guard let episodeAirDate = episode.values.first else { return }
        guard let episodeWithFormattedAirDate = DateLogicController.shared.formatAirDate(episodeAirDate: episodeAirDate) else { return }
        
        self.showNextEpisodeLabel.text = String(episodeNumber)
        self.showNextEpisodeAirDateLabel.text = episodeWithFormattedAirDate
    }
}
