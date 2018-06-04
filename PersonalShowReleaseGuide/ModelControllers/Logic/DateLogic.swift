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
    let season = ShowModelController.shared.season
    var today = ""
    
    
    // MARK: - Methods
    func currentDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "YYYY-MM-d"
        let today = dateFormatter.string(from: Date())
        self.today = today
        print("Today's Date is: \(today)")
    }
    
    // Iterates through [Season] to get the most recent season then returns the season number
    func findClosestEpisodeDate() { // -> [Int : String] {
        var closestSeason = "1800-01-01"
        let seasonNumbers = season.compactMap( {$0.seasonNumber} )
        let seasonAirDates = season.compactMap( {$0.seasonAirDate} )
        var seasonDictionary: [Int : String] = [:]
        
        for (seasonNumber, seasonAirDate) in zip(seasonNumbers, seasonAirDates) {
            if seasonAirDate <= today {
                if seasonAirDate > closestSeason {
                    closestSeason = seasonAirDate
                    seasonDictionary = [seasonNumber : seasonAirDate]
                    print("Season Dictionary: \(seasonDictionary)")
                }
            }
        }
        print("Closest date to current: \(closestSeason)")
//        return seasonDictionary
    }
}
