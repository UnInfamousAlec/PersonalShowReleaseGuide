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
    @IBOutlet weak var seriesPoster: UIImageView!
    @IBOutlet weak var seriesNameAndAirDateLabel: UILabel!
    @IBOutlet weak var seasonNumberCurrentOrLastLabel: UILabel!
    @IBOutlet weak var seasonNumberLabel: UILabel!
    @IBOutlet weak var episodeNumberNextOrLastLabel: UILabel!
    @IBOutlet weak var episodeNumberLabel: UILabel!
    @IBOutlet weak var episodeNextOrLastAirDateLabel: UILabel!
    @IBOutlet weak var episodeAirDateLabel: UILabel!
    

    // MARK: - Properties
    let today = DateLogicController.shared.today
    let dateFormat = "MMMM dd, YYYY"
    var series: Series? {
        didSet {
            updateCellWithSeries()
            updateCellWithSeasonAndEpisode()
            updateCellWithPoster()
        }
    }
    
    
    // MARK: - Methods
    func updateCellWithPoster() {
        guard let series = series else { return }
        
        seriesPoster.image = series.posterImage
    }
    
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
        
        self.seriesNameAndAirDateLabel.text = "\(series.name) \(airYear)"
    }
    
    func updateCellWithSeasonAndEpisode() {
        guard let seriesID = series?.ID else { return }
        
        let seasonNumber = DateLogicController.shared.findMostCurrentSeason(seriesID: seriesID)
        
        if seasonNumber == -1 {
            seasonNumberLabel.text = "?"
        } else {
            seasonNumberLabel.text = String(seasonNumber)
        }
        
        let episodes = DateLogicController.shared.findMostCurrentEpisode(seriesID: seriesID)
        guard let episodeNumber = episodes.keys.first else { return }
        guard let episodeAirDate = episodes.values.first else { return }
        guard let episodeWithFormattedAirDate = DateLogicController.shared.formatAirDate(withFormat: dateFormat, forDate: episodeAirDate) else { return }
        
        if episodeNumber == -1 {
            episodeNumberLabel.text = "?"
        } else {
            episodeNumberLabel.text = String(episodeNumber)
        }
        
        if episodeAirDate == "" {
            episodeAirDateLabel.text = "Unknown Date"
        }
        else if episodeAirDate == self.today {
            episodeNextOrLastAirDateLabel.text = "Next Episode Airs Today!"
            episodeAirDateLabel.text = String(episodeWithFormattedAirDate)
        }
        else if episodeAirDate < self.today {
            seasonNumberCurrentOrLastLabel.text = "Last Season:"
            episodeNumberNextOrLastLabel.text = "Last Episode:"
            episodeNextOrLastAirDateLabel.text = "Last Episode Air Date:"
            episodeAirDateLabel.text = String(episodeWithFormattedAirDate)
        }
        else if episodeAirDate > self.today {
            episodeAirDateLabel.text = String(episodeWithFormattedAirDate)
        }
    }
}
