//
//  DateLogicController.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 4/26/18.
//  Copyright © 2018 UnInfamous Games. All rights reserved.
//

import Foundation

class DateLogicController {
    
    // MARK: - Singleton
    static let shared = DateLogicController()
    
    
    // MARK: - Properties
    var today = ""
    
    
    // MARK: - Methods
    func currentDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let today = dateFormatter.string(from: Date())
        self.today = today
        print("Today's Date is: \(today)\n")
    }
    
    // Iterates through [Season] to get the most recent season then returns the season number
    func findMostCurrentSeason(seriesID: Int) -> Int {
        
        let seriesDictionary = TelevisionModelController.shared.seasonDictionary
        let series = seriesDictionary[seriesID]
        let seasons = series.map{$0.seasons}! //FIXME
        
        let seasonNumbers = seasons.compactMap( {$0.seasonNumber} ).reversed()
        let seasonAirDates = seasons.compactMap( {$0.seasonAirDate} ).reversed()
        
        if seasonNumbers.count != seasonAirDates.count {
            print("HUGE ISSUE! seasonNumbers & seasonAirDates are somehow not the same amount! \(#function)")
        }
        var mostCurrentSeason = -1
        
        // Create season number based on today's date
        for (seasonNumber, seasonAirDate) in zip(seasonNumbers, seasonAirDates) {
            print("\(seasonNumber) - \(seasonAirDate)\n")
            if seasonAirDate >= today {
                mostCurrentSeason = seasonNumber
                break
            } else if seasonAirDate < today {
                mostCurrentSeason = seasonNumber
                break
            }
        }
        return mostCurrentSeason
    }
    
    // Iterates through [Episode] to get the most recent episode then returns the season number
    func findMostCurrentEpisode(seriesID: Int) -> Int {
        
        let episodeDictionary = TelevisionModelController.shared.episodeDictionary
        let series = episodeDictionary[seriesID]
        let episodes = series.map{$0.episodes}! //FIXME
        
        let episodeNumbers = episodes.compactMap( {$0.episodeNumber} ).reversed()
        let episodeAirDates = episodes.compactMap( { $0.episodeAirDate} ).reversed()
        
        if episodeNumbers.count != episodeAirDates.count {
            print("HUGE ISSUE! episodeNumbers & episodeAirDates are somehow not the same amount! \(#function)")
        }
        var mostCurrentEpisode = -1
        
        // Create episode number based on today's date
        for (episodeNumber, episodeAirDate) in zip(episodeNumbers, episodeAirDates) {
            print("\(episodeNumber) - \(episodeAirDate)\n")
            if episodeAirDate >= today {
                mostCurrentEpisode = episodeNumber
                break
            } else if episodeAirDate < today {
                mostCurrentEpisode = episodeNumber
                break
            }
        }
        return mostCurrentEpisode
    }
}
