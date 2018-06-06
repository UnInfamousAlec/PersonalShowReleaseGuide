//
//  ShowModelController.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 4/26/18.
//  Copyright © 2018 UnInfamous Games. All rights reserved.
//

import Foundation

class TelevisionModelController {
    
    // MARK: - Singleton
    static let shared = TelevisionModelController()
    
    
    // MARK: - Properties
    var series: [Series] = []
    var seasons: [Season] = []
    var episodes: [Episode] = []
    var seriesIDs: [Int] = []
    var currentSeason: [Int] = []
    var currentEpisode: [Int] = []
    var nextEpisodeAirDate: [String] = []
    let baseShowURL = URL(string: "https://api.themoviedb.org/3/search/tv?")!
    
    
    // MARK: - Methods
    // Get list of series' from search
    func fetchSeries(by searchTerm: String, completion: @escaping(Bool) -> Void) {
        currentSeason.removeAll()
        currentEpisode.removeAll()
        
        let queries = ["api_key" : "1f76e7734a01ecc55ff5054b1d2a3e82", "query" : "\(searchTerm)", "language" : "en-US"]
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
                    let shows = seriesDictionary.results.compactMap( {$0} )
                    shows.forEach{ print("Series Results: \($0.name, $0.id, $0.pilotAirDate, $0.language)") }
                    self.series = shows
                    self.removeNonEnglishFromShow()
                    self.seriesIDs = self.series.map{$0.id}
                    completion(true)
                } catch let error {
                    print("Error handling series data: \(error) - \(error.localizedDescription)\n")
                    completion(false)
                    return
                }
            }
        }
        .resume()
    }
    
    // Fetch Series Seasons
    func fetchSeasons(withID seriesID: Int, completion: @escaping(Bool) -> Void) {
                
        let baseSeasonURL = "https://api.themoviedb.org/3/tv/"
        let midSeasonURL = "\(seriesID)" + "?"
        let queries = ["api_key" : "1f76e7734a01ecc55ff5054b1d2a3e82", "language" : "en-US"]
        
        let seasonURL = URL(string: baseSeasonURL + midSeasonURL)!.withQueries(queries)!
        print("Requested Season URL: \(seasonURL) for Series: \(seriesID)\n")
        
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
                    let seasonDictionary = try jsonDecoder.decode(SeriesForSeason.self, from: data)
                    let seasons = seasonDictionary.seasons.map({ (season) -> Season in
                        if season.seasonAirDate == nil {
                            season.seasonAirDate = ""
                        }
                        return season
                    })
                    
                    // Print to console for debug
                    print("Name: \(seasonDictionary.name)  In Production: \(seasonDictionary.inProduction)  Status: \(seasonDictionary.status)")
                    seasons.forEach{ print("\($0.seasonName, $0.seasonNumber, $0.seasonAirDate!)") }
                    
                    self.seasons = seasons
                    self.currentSeason.append(DateLogic.shared.findMostCurrentSeason())
                    print("\"Current\" Season Numbers: \(self.currentSeason)\n")
                    completion(true)
                } catch let error {
                    print("Error handling season data: \(error) - \(error.localizedDescription)\n")
                    completion(false)
                    return
                }
            }
        }
        .resume()
    }
    
    // Fetch Season Episode Numbers
    func fetchEpisodes(withID seriesID: Int, andSeason seasonNumber: Int, completion: @escaping(Bool) -> Void) {
        
        let baseEpisodeURL = "https://api.themoviedb.org/3/tv/"
        let midEpisodeURL = "\(seriesID)" + "/season/" + "\(seasonNumber)" + "?"
        let queries = ["api_key" : "1f76e7734a01ecc55ff5054b1d2a3e82", "language" : "en-US"]
        
        let episodeURL = URL(string: baseEpisodeURL + midEpisodeURL)!.withQueries(queries)!
        print("Requested Episode URL: \(episodeURL)\n")
        
//        if seasonNumber == 1000000 {
//            self.currentEpisode.append(1000000)
//            completion(true)
//            return
//        }
        
        URLSession.shared.dataTask(with: episodeURL) { (data, response, error) in
            
            if let error = error {
                self.currentEpisode.append(1000000)
                print("Error with episode fetch request: \(error) - \(error.localizedDescription)"); print("\n")
                completion(true)
                return
            }
            
//            if let response = response {
//                print("TMDB Episode Response: \(response)\n")
//                completion(false)
//            }
            
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let episodeDictionary = try jsonDecoder.decode(SeasonForEpisode.self, from: data)
                    let episodes = episodeDictionary.episodes.map({ (episode) -> Episode in
                        if episode.episodeAirDate == nil {
                            episode.episodeAirDate = ""
                        }
                        return episode
                    })
                    
                    // Print to console for debug
                    episodes.forEach{ print("\($0.name, $0.episodeNumber, $0.episodeAirDate)") }
                    
                    self.episodes = episodes
                    self.currentEpisode.append(DateLogic.shared.findMostCurrentEpisode())
                    print("\"Current\" Episode Numbers: \(self.currentEpisode)\n")
                    completion(true)
                } catch let error {
                    print("Error handling episode data: \(error) - \(error.localizedDescription)\n")
                    completion(false)
                    return
                }
            }
        }
        .resume()
    }
    
    func removeNonEnglishFromShow() {
        var nonEnglishIndexLocations: [Int] = []
        for (index, show) in self.series.enumerated() {
            if show.language != "en" {
                nonEnglishIndexLocations.append(index)
            }
        }
        while nonEnglishIndexLocations.count > 0 {
            series.remove(at: nonEnglishIndexLocations.last!)
            nonEnglishIndexLocations.removeLast()
        }
    }
}
