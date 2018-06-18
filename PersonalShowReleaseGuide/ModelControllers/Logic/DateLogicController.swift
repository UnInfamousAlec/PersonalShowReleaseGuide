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
        
        let entireSeries = TelevisionModelController.shared.entireSeries
        var mostCurrentSeasonNumber: Int = -1
        
        for series in entireSeries {
            if seriesID == series.ID {
                let seasons = series.seasons
                let seasonNumbers = seasons.compactMap( {$0.seasonNumber ?? -1} ).reversed()
                let seasonAirDates = seasons.compactMap( {$0.seasonAirDate ?? ""} ).reversed()
                
                if seasonNumbers.count != seasonAirDates.count {
                    print("HUGE ISSUE! seasonNumbers & seasonAirDates are somehow not the same amount! \(#function)")
                }
                
                // Create season number based on today's date
                for (seasonNumber, seasonAirDate) in zip(seasonNumbers, seasonAirDates) {
                    print("\nSeries: \(series.name, series.ID) | Most Current Season: \(seasonNumber) - \(seasonAirDate)")
                    if seasonAirDate >= today {
                        mostCurrentSeasonNumber = seasonNumber
                        break
                    } else if seasonAirDate < today {
                        mostCurrentSeasonNumber = seasonNumber
                        break
                    }
                }
                return mostCurrentSeasonNumber
            }
        }
        return mostCurrentSeasonNumber
    }
    
    // Iterates through [Episode] to get the most recent episode number and episode air date
    func findMostCurrentEpisode(seriesID: Int) -> [Int : String] {
        
        let entireSeries = TelevisionModelController.shared.entireSeries
        var mostCurrentEpisode: [Int : String] = [-1 : ""]
        
        for series in entireSeries {
            if series.ID == seriesID {
                for season in series.seasons {
                    guard let episodes = season.episodes else { continue }
                    let episodeNumbers = episodes.compactMap( {$0.episodeNumber} )//.reversed()
                    let episodeAirDates = episodes.compactMap( {$0.episodeAirDate ?? ""} )//.reversed()
                    
                    if episodeNumbers.count != episodeAirDates.count {
                        print("HUGE ISSUE! episodeNumbers & episodeAirDates are somehow not the same amount! \(#function)")
                    }
                    
                    // Create episode number based on today's date // Need to restructure this based off of https://api.themoviedb.org/3/tv/66636/season/4?language=en-US&api_key=1f76e7734a01ecc55ff5054b1d2a3e82&page=1
                    
                    for (episodeNumber, episodeAirDate) in zip(episodeNumbers, episodeAirDates) {
                        print("Series: \(series.name, series.ID) | Season: \(season.seasonNumber ?? -1) | Most Current Episode: \(episodeNumber) - \(episodeAirDate)")
                        
                        if episodeAirDate == today {
                            mostCurrentEpisode = [episodeNumber : episodeAirDate]
                            break
                        } else if episodeAirDate > today {
                            mostCurrentEpisode = [episodeNumber : episodeAirDate]
                            break
                        } else if episodeAirDate == episodeAirDates.last {
                            mostCurrentEpisode = [episodeNumber : episodeAirDate]
                            break
                        }
                    }
                    return mostCurrentEpisode
                }
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
