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
        let queries = ["api_key" : "1f76e7734a01ecc55ff5054b1d2a3e82", "query" : "\(searchTerm)", "language" : "en-US"]
        let requestURL = baseShowURL.withQueries(queries)!
        print("\nRequestedURL: \(requestURL)\n")
        
        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            
            if let error = error {
                print("Error with fetch request: \(error) - \(error.localizedDescription)\n")
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
                    let showDictionary = try jsonDecoder.decode(SeriesResults.self, from: data)
                    let shows = showDictionary.results.compactMap( {$0} )
                    //print("Shows dictionary: \(showDictionary.results)\n")
                    self.series = shows
                    self.removeNonEnglishFromShow()
                    self.seriesIDs = self.series.map{$0.id}
                    completion(true)
                } catch let error {
                    print("Error handling data: \(error) - \(error.localizedDescription)\n")
                    completion(false)
                    return
                }
            }
        }
        .resume()
    }
    
    // Fetch Series Seasons
    func fetchSeasons(completion: @escaping(Bool) -> Void) {
        
        guard let seriesID = self.seriesIDs.first else { return }
        seriesIDs.remove(at: 0)
        
        let baseShowIDURL = "https://api.themoviedb.org/3/tv/"
        let midURL = "\(seriesID)" + "?"
        let queries = ["api_key" : "1f76e7734a01ecc55ff5054b1d2a3e82", "language" : "en-US"]
        
        let seriesURL = URL(string: baseShowIDURL + "\(midURL)")!.withQueries(queries)!
        print("\nRequestedSeasonURL: \(seriesURL)\n")
        
        URLSession.shared.dataTask(with: seriesURL) { (data, response, error) in
            
            if let error = error {
                print("Error with fetch request: \(error) - \(error.localizedDescription)\n")
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
                    let series = try jsonDecoder.decode(SeriesForSeason.self, from: data)
                    let seasons = series.seasons.map({ (season) -> Season in
                        if season.seasonAirDate == nil {
                            season.seasonAirDate = ""
                        }
                        return season
                    }) // Get this to turn nil into ""
                    print("\nName: \(series.name)  In Production: \(series.inProduction)  Status: \(series.status)")
                    seasons.forEach{ print( "\($0.seasonName, $0.seasonNumber, $0.seasonAirDate!)")}
                    self.seasons = seasons
                    self.currentSeason.append(DateLogic.shared.findCurrentSeason())
                    completion(true)
                } catch let error {
                    print("Error handling data: \(error) - \(error.localizedDescription)\n")
                    completion(false)
                    return
                }
            }
        }
        .resume()
    }
    
//    // Fetch Season Episode Numbers
//      //https://api.themoviedb.org/3/tv/37680/season/1?api_key=1f76e7734a01ecc55ff5054b1d2a3e82&language=en-US
//    func fetchEpisodes(withID ID: Int, andSeason number: Int, completion: @escaping(Bool) -> Void) {
//
//        let baseShowIDURL = "https://api.themoviedb.org/3/tv/"
//
//    }
    
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
