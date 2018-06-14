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
    @IBOutlet weak var seriesCurrentOrLastLabel: UILabel!
    @IBOutlet weak var showCurrentSeasonLabel: UILabel!
    @IBOutlet weak var seriesNextOrLastLabel: UILabel!
    @IBOutlet weak var showNextEpisodeLabel: UILabel!
    @IBOutlet weak var seriesNextOrLastAirDateLabel: UILabel!
    @IBOutlet weak var showNextEpisodeAirDateLabel: UILabel!
    

    // MARK: - Properties
    var series: Series? {
        didSet {
            updateCellWithSeries()
            updateCellWithSeasonAndEpisode()
        }
    }
    
    
    // MARK: - Methods
    func updateCellWithSeries() {
        guard let series = series else { return }
        let pilotAirDate = series.pilotAirDate ?? ""
        
        var year = ""
        for letter in pilotAirDate {
            if letter == "-" {
                break
            }
            year.append(letter)
        }
        
        var airYear = ""
        if year.count > 0 {
            airYear = "(\(year))"
        } else {
            airYear = "(Unknown)"
        }
        
        self.showTitleLabel.text = "\(series.name) \(airYear)"
    }
    
    func updateCellWithSeasonAndEpisode() {
        guard let seriesID = series?.ID else { return }
        
        let seasonNumber = DateLogicController.shared.findMostCurrentSeason(seriesID: seriesID)
        if seasonNumber == -1 {
            showCurrentSeasonLabel.text = "N/A"
        } else {
            showCurrentSeasonLabel.text = String(seasonNumber)
        }
        
        let episodes = DateLogicController.shared.findMostCurrentEpisode(seriesID: seriesID)
        guard let episodeNumber = episodes.keys.first else { return }
        guard let episodeAirDate = episodes.values.first else { return }
        guard let episodeWithFormattedAirDate = DateLogicController.shared.formatAirDate(episodeAirDate: episodeAirDate) else { return }
        
        showNextEpisodeLabel.text = String(episodeNumber)
        
        if episodeAirDate == "" {
            showNextEpisodeAirDateLabel.text = "Unknown Date"
        } else {
            showNextEpisodeAirDateLabel.text = String(episodeWithFormattedAirDate)
        }
    }
}
