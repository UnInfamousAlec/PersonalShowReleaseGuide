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
    func findCurrentSeason() -> Int {
        season = TelevisionModelController.shared.seasons
//        var closestSeason = "1800-01-01"
        var closestSeasonNumber = 0
        let seasonNumbers = season.compactMap( {$0.seasonNumber} ).reversed()
        let seasonAirDates = season.compactMap( {$0.seasonAirDate} ).reversed()
        if seasonNumbers.count != seasonAirDates.count {
            print("HUGE ISSUE! seasonNumbers & seasonAirDates are somehow not the same amount! \(#function)")
        }
        
        // Create season number to date dictionary
        for (seasonNumber, seasonAirDate) in zip(seasonNumbers, seasonAirDates) {
            print("\(seasonNumber) - \(seasonAirDate)")
            if seasonAirDate >= today {
//                closestSeason = seasonAirDate
                closestSeasonNumber = seasonNumber
                break
            } else if seasonAirDate < today {
//                closestSeason = seasonAirDate
                closestSeasonNumber = seasonNumber
                break
            }
        }
        return closestSeasonNumber
    }
}
