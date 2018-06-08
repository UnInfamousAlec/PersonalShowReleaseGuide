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
            print("Most Current Season: \(seasonNumber) - \(seasonAirDate)\n")
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
    func findMostCurrentEpisode(seriesID: Int) -> [Int : String] {
        
        let episodeDictionary = TelevisionModelController.shared.episodeDictionary
        let series = episodeDictionary[seriesID]
        let episodes = series.map{$0.episodes}! //FIXME
        
        let episodeNumbers = episodes.compactMap( {$0.episodeNumber} ).reversed()
        let episodeAirDates = episodes.compactMap( { $0.episodeAirDate} ).reversed()
        
        if episodeNumbers.count != episodeAirDates.count {
            print("HUGE ISSUE! episodeNumbers & episodeAirDates are somehow not the same amount! \(#function)")
        }
        var mostCurrentEpisode = [Int : String]()
        
        // Create episode number based on today's date
        for (episodeNumber, episodeAirDate) in zip(episodeNumbers, episodeAirDates) {
            print("Most Current Episode: \(episodeNumber) - \(episodeAirDate)\n")
            if episodeAirDate >= today {
                mostCurrentEpisode = [episodeNumber : episodeAirDate]
                break
            } else if episodeAirDate < today {
                mostCurrentEpisode = [episodeNumber : episodeAirDate]
                break
            }
        }
        return mostCurrentEpisode
    }
    
    func formatAirDate(episodeAirDate: String) -> String? {
//        let selectedLanguage = TelevisionModelController.shared.selectedLanguage
//        let selectedCountry = TelevisionModelController.shared.selectedCountry
//        dateFormatter.locale = Locale(identifier: "\(selectedLanguage)_\(selectedCountry)")
        
        let dateFormatterToDate = DateFormatter()
        dateFormatterToDate.dateFormat = "YYYY-MM-dd"
        guard let date = dateFormatterToDate.date(from: episodeAirDate) else { return episodeAirDate }
        
        let dateFormatterToString = DateFormatter()
        dateFormatterToString.dateFormat = "MMMM dd, YYYY"
        let dateAsString = dateFormatterToString.string(from: date)
        
        return dateAsString
        }
}
