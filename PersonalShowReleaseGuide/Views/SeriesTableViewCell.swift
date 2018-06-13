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
            showAirYear(series: series)
        }
    }
    
    var seasons: SeriesForSeason? {
        didSet {
            showSeasonNumber(series: series)
        }
    }
    
    var episodes: SeasonForEpisode? {
        didSet {
            showEpisode(series: series)
        }
    }
    
    
    // MARK: - Methods
    func showAirYear(series: Series?) {
        
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
    
    func showSeasonNumber(series: Series?) {
        
        guard let seriesID = series?.ID else { return }
        let seasonNumber = DateLogicController.shared.findMostCurrentSeason(seriesID: seriesID)
        
        if seasonNumber == -1 {
            self.showCurrentSeasonLabel.text = "N/A"
        } else {
            self.showCurrentSeasonLabel.text = String(seasonNumber)
        }
    }
    
    func showEpisode(series: Series?) {
        
        guard let seriesID = series?.ID else { return }
        let seasonNumber = DateLogicController.shared.findMostCurrentSeason(seriesID: seriesID)
        let episode = DateLogicController.shared.findMostCurrentEpisode(seriesID: seriesID)
        
        guard let episodeNumber = episode.keys.first else { return }
        guard let episodeAirDate = episode.values.first else { return }
        guard let episodeWithFormattedAirDate = DateLogicController.shared.formatAirDate(episodeAirDate: episodeAirDate) else { return }
        
        if seasonNumber == -1 {
            self.showNextEpisodeLabel.text = "N/A"
            self.showNextEpisodeAirDateLabel.text = "Unknown"
        } else {
            self.showNextEpisodeLabel.text = String(episodeNumber)
            self.showNextEpisodeAirDateLabel.text = episodeWithFormattedAirDate
        }
    }
}
