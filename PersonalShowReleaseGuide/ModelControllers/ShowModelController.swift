//
//  ShowModelController.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 4/26/18.
//  Copyright © 2018 UnInfamous Games. All rights reserved.
//

import Foundation

class ShowModelController {
    
    // MARK: - Singleton
    static let shared = ShowModelController()
    
    
    // MARK: - Properties
    var shows: [Show] = []
    var season: [SeasonArray] = []
    let baseShowURL = URL(string: "https://api.themoviedb.org/3/search/tv?")!
    
    
    // MARK: - Methods
    // Get list of series' from search
    func fetchShows(by searchTerm: String, completion: @escaping(Bool) -> Void) {
        
        let queries = ["api_key" : "9d94523b28ef0a99fe43078ea391db1c", "query" : "\(searchTerm)", "language" : "en-US"]
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
                    let showDictionary = try jsonDecoder.decode(ShowResults.self, from: data)
                    let shows = showDictionary.results.compactMap( {$0} )
                    print("Shows dictionary: \(showDictionary.results)\n")
                    self.shows = shows
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
    
//     Get season ID from series fetch
    func fetchSeasonIDs(with ID: Int, completion: @escaping(Bool) -> Void) {
        
        let baseShowIDURL = "https://api.themoviedb.org/3/tv/"
        let seriesID = "\(ID)" + "?" // 37680 Needs to be replaced with series ID from fetchMovies
        
        
        let queries = ["api_key" : "9d94523b28ef0a99fe43078ea391db1c", "language" : "en-US"]
        
        let seriesURL = URL(string: baseShowIDURL + "\(seriesID)")!.withQueries(queries)!
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
                    let series = try jsonDecoder.decode(Series.self, from: data)
                    let season = series.seasons.compactMap( {$0} )
                    print("Season Ojbect: \(season)")
                    self.season = season
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

    func repeatFetchSeasonIDs(completion: @escaping(Bool) -> Void) {
        
        let seriesID = shows.compactMap( {$0.id} )
        let printSeriesName = shows.compactMap( {$0.title} )
        var seriesName = ""
        print("SeriesIDArray\(seriesID)")
        
        for name in printSeriesName {
            seriesName = name
            print("Series name is: \(seriesName)")
        }
        
        for number in seriesID {
            fetchSeasonIDs(with: number) { (success) in
                if success {
                    completion(true)
                }
                
                if !success {
                    completion(false)
                }
            }
        }
    }
}

