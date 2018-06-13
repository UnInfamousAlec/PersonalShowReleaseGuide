//
//  TelevisionModelController.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 4/26/18.
//  Copyright © 2018 UnInfamous Games. All rights reserved.
//

import Foundation

class TelevisionModelController {
    
    // MARK: - Shared instance
    static let shared = TelevisionModelController()
    
    
    // MARK: - Properties
    let baseShowURL = URL(string: "https://api.themoviedb.org/3/search/tv?")!
    var selectedLanguage = "en"
    var selectedCountry = "US"
    var adultContent = false
    var pageRequest = 1
    
    var seriesDictionary = [Int : Series]()
    var seasonDictionary = [Int : SeriesForSeason]()
    var episodeDictionary = [Int : SeasonForEpisode]()
    
    var entireSeries = [Series]()
    
    
    // MARK: - Methods
    // Get list of series' from search
    func fetchSeries(by searchTerm: String, completion: @escaping(Bool) -> Void) {
        
        seriesDictionary.removeAll()
        seasonDictionary.removeAll()
        episodeDictionary.removeAll()
        entireSeries.removeAll()
        
        let queries = ["api_key" : "1f76e7734a01ecc55ff5054b1d2a3e82", "query" : "\(searchTerm)", "language" : "\(selectedLanguage)-\(selectedCountry)", "page" : "\(pageRequest)"]
        let requestSeriesURL = baseShowURL.withQueries(queries)!
        print("\nRequested Series URL: \(requestSeriesURL)\n")
        
        URLSession.shared.dataTask(with: requestSeriesURL) { (data, response, error) in
            
            if let error = error {
                print("Error with series fetch request: \(error) - \(error.localizedDescription)\n")
                completion(false)
                return
            }
            
//            if let response = response {
//                print("TMDB Response: \(response)\n")
//                completion(false)
//            }
            
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let seriesDictionary = try jsonDecoder.decode(SeriesResults.self, from: data)
                    let seriesArray = seriesDictionary.results.compactMap( {$0} )
                    seriesArray.forEach{ print("Series Results: \($0.name, $0.ID, $0.pilotAirDate, $0.language)") }; print("\n")
                    self.entireSeries = seriesArray
                    
                    for series in seriesArray {
                        self.seriesDictionary.updateValue(series, forKey: series.ID)
                        self.removeNonEnglishFromShow(series: series)
                    }
                    completion(true)
                } catch let error {
                    print("Error handling series data: \(error) - \(error.localizedDescription)\n")
                    completion(false)
                    return
                }
            }
        }.resume()
    }
    
    // Fetch Series Seasons
    func fetchSeasons(withID seriesID: Int, completion: @escaping(Bool) -> Void) {
        
        let baseSeasonURL = "https://api.themoviedb.org/3/tv/"
        let midSeasonURL = "\(seriesID)" + "?"
        let queries = ["api_key" : "1f76e7734a01ecc55ff5054b1d2a3e82", "language" : "en-US"]
        
        let seasonURL = URL(string: baseSeasonURL + midSeasonURL)!.withQueries(queries)!
        print("Requested Season URL: \(seasonURL)\n")
        
        URLSession.shared.dataTask(with: seasonURL) { (data, response, error) in
            
            if let error = error {
                print("Error with season fetch request: \(error) - \(error.localizedDescription)\n")
                completion(false)
                return
            }
            
//            if let response = response {
//                print("TMDB Season Response: \(response)\n")
//                completion(false)
//            }
            
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let seriesForSeasonDictionary = try jsonDecoder.decode(SeriesForSeason.self, from: data)
                    
                    for series in self.entireSeries {
                        
                    }
                    
                    self.seasonDictionary.updateValue(seriesForSeasonDictionary, forKey: seriesForSeasonDictionary.seriesID)
                    
                    let seasons = seriesForSeasonDictionary.seasons.map({ (season) -> Season in
                        if season.seasonAirDate == nil {
                            season.seasonAirDate = ""
                            return season
                        }
                        return season
                    })
                    
                    print("Name: \(seriesForSeasonDictionary.nameOfSeason)  Series ID: \(seriesForSeasonDictionary.seriesID)  In Production: \(seriesForSeasonDictionary.inProduction)  Status: \(seriesForSeasonDictionary.status)")
                    seasons.forEach{ print("\($0.seasonName!, $0.seasonNumber!, $0.seasonAirDate!)") }
                    
                    self.addEpisodeToEmptySesaons(seriesID: seriesID, seriesForSeason: seriesForSeasonDictionary)
                    self.seasonDictionary.updateValue(seriesForSeasonDictionary, forKey: seriesForSeasonDictionary.seriesID)
                    completion(true)
                } catch let error {
                    print("Error handling season data: \(error) - \(error.localizedDescription)\n")
                    completion(false)
                    return
                }
            }
        }.resume()
    }
    
    // Fetch Season Episode Numbers
    func fetchEpisodes(withID seriesID: Int, andSeason seasonNumber: Int, completion: @escaping(Bool) -> Void) {
        
        let baseEpisodeURL = "https://api.themoviedb.org/3/tv/"
        let midEpisodeURL = "\(seriesID)" + "/season/" + "\(seasonNumber)" + "?"
        let queries = ["api_key" : "1f76e7734a01ecc55ff5054b1d2a3e82", "language" : "en-US"]
        
        let episodeURL = URL(string: baseEpisodeURL + midEpisodeURL)!.withQueries(queries)!
        print("Requested Episode URL: \(episodeURL)\n")
        
        URLSession.shared.dataTask(with: episodeURL) { (data, response, error) in
            
            if let error = error {
                print("Error with episode fetch request: \(error) - \(error.localizedDescription)"); print("\n")
                completion(false)
                return
            }
            
//            if let response = response {
//                print("TMDB Episode Response: \(response)\n")
//                completion(false)
//            }
            
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let seasonForEpisodeDictionary = try jsonDecoder.decode(SeasonForEpisode.self, from: data)
                    let episodes = seasonForEpisodeDictionary.episodes.map({ (episode) -> Episode in
                        if episode.episodeAirDate == nil {
                            episode.episodeAirDate = ""
                            return episode
                        }
                        return episode
                    })
                    
                    episodes.forEach{ print("Episode Details: \($0.episodeName, $0.episodeNumber, $0.episodeAirDate!)") }
                    
                    self.episodeDictionary.updateValue(seasonForEpisodeDictionary, forKey: seriesID)
                    completion(true)
                } catch let error {
                    print("Error handling episode data: \(error) - \(error.localizedDescription)\n")
                    completion(false)
                    return
                }
            }
        }.resume()
    }
    
    func removeNonEnglishFromShow(series: Series) {
        if series.language != "en" {
            seriesDictionary.removeValue(forKey: series.ID)
        }
    }
    
    func addEpisodeToEmptySesaons(seriesID: Int, seriesForSeason dictionary: SeriesForSeason) {
        if dictionary.seasons.count == 0 {
            createEmptyEpisode(seriesID: seriesID)
        }
    }
    
//    func checkForEmptyEpisode(seriesID: Int) -> Episode? {
//        guard let seriesForSeason = self.seasonDictionary[seriesID] else { return nil}
//        if  seriesForSeason.seasons.count != 0 {
//            episodeDictionary.
//        }
//        return
//    }
    
    func createEmptyEpisode(seriesID: Int) {
        
        let seasonID = 0; let episodeName = ""; let episodeNumber = 0; let episodeAirDate = ""; let episodeOverview = ""
        let emptyEpisode = Episode(seasonID: seasonID, episodeName: episodeName, episodeNumber: episodeNumber, episodeAirDate: episodeAirDate, episodeOverview: episodeOverview)
        
        var emptyEpisodeArray = [Episode]()
        emptyEpisodeArray.append(emptyEpisode)
        
        let seasonForEpisode = SeasonForEpisode(episodes: emptyEpisodeArray)
        
        self.episodeDictionary.updateValue(seasonForEpisode, forKey: seriesID)
    }
}
