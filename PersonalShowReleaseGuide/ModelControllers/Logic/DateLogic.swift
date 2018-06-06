//
//  ClosestEpisodeDate.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 4/26/18.
//  Copyright © 2018 UnInfamous Games. All rights reserved.
//

import Foundation

class DateLogic {
    
    // MARK: - Singleton
    static let shared = DateLogic()
    
    
    // MARK: - Properties
    var season: [Season] = []
    var episode: [Episode] = []
    var today = ""
    
    
    // MARK: - Methods
    func currentDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let today = dateFormatter.string(from: Date())
        self.today = today
        print("Today's Date is: \(today)")
    }
    
    // Iterates through [Season] to get the most recent season then returns the season number
    func findMostCurrentSeason() -> Int {
        self.season = TelevisionModelController.shared.seasons
//        var closestSeason = "1800-01-01"
        var mostCurrentSeason = 0
        let seasonNumbers = self.season.compactMap( {$0.seasonNumber} ).reversed()
        let seasonAirDates = self.season.compactMap( {$0.seasonAirDate} ).reversed()
        
        if seasonNumbers.count != seasonAirDates.count {
            print("HUGE ISSUE! seasonNumbers & seasonAirDates are somehow not the same amount! \(#function)")
        }
        
        // Create season number to date dictionary
        for (seasonNumber, seasonAirDate) in zip(seasonNumbers, seasonAirDates) {
            print("\(seasonNumber) - \(seasonAirDate)\n")
            if seasonAirDate >= today {
//                closestSeason = seasonAirDate
                mostCurrentSeason = seasonNumber
                break
            } else if seasonAirDate < today {
//                closestSeason = seasonAirDate
                mostCurrentSeason = seasonNumber
                break
            }
        }
        return mostCurrentSeason
    }
    
    func findMostCurrentEpisode() -> Int {
        self.episode = TelevisionModelController.shared.episodes
        var mostCurrentEpisode = 0
        let episodeNumbers = self.episode.compactMap( {$0.episodeNumber} ).reversed()
        let episodeAirDates = self.episode.compactMap( { $0.episodeAirDate} ).reversed()
        
        if episodeNumbers.count != episodeAirDates.count {
            print("HUGE ISSUE! episodeNumbers & episodeAirDates are somehow not the same amount! \(#function)")
        }
        
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
