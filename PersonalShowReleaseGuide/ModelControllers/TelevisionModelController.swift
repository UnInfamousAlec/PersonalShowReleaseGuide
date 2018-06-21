//
//  TelevisionModelController.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 4/26/18.
//  Copyright © 2018 UnInfamous Games. All rights reserved.
//

import UIKit

class TelevisionModelController {
    
    // MARK: - Shared instance
    static let shared = TelevisionModelController()
    
    
    // MARK: - Properties
    var selectedLanguage = "en"
    var selectedCountry = "US"
    var adultContent = false
    var pageRequest = 1
    
    var seriesIDs = [Int]()
    var entireSeries = [Series]()
    
    
    // MARK: - Methods
    // Get list of series' from search
    func fetchSeriesIDs(by searchTerm: String, completion: @escaping(Bool) -> Void) {
                
        let beginPointSeriesURL = URL(string: "https://api.themoviedb.org/3/search/tv?")!
        let endPointQuerySeriesURL = ["api_key" : "1f76e7734a01ecc55ff5054b1d2a3e82", "query" : "\(searchTerm)", "language" : "\(selectedLanguage)-\(selectedCountry)", "page" : "\(pageRequest)"]
        let requestedSeriesURL = beginPointSeriesURL.withQueries(endPointQuerySeriesURL)!
        print("\nRequested Search URL: \(requestedSeriesURL)\n")
        
        URLSession.shared.dataTask(with: requestedSeriesURL) { (data, response, error) in
            
            if let error = error {
                print("Error with search fetch request: \(requestedSeriesURL) \(error) - \(error.localizedDescription)\n")
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
                    let searchedDictionary = try jsonDecoder.decode(SearchedDictionary.self, from: data)
                    let seriesIDs = searchedDictionary.results.map( {$0.ID} )
                    self.seriesIDs = seriesIDs
                    completion(true)
                } catch let error {
                    print("Error handling search data: \(requestedSeriesURL) | \(error) - \(error.localizedDescription)\n")
                    completion(false)
                    return
                }
            }
        }.resume()
    }
    
    // Fetch Series Seasons
    func fetchSeriesAndSeasons(withSeriesID seriesID: Int, completion: @escaping(Bool) -> Void) {
        
        let beginPointSeriesAndSeasonURL = "https://api.themoviedb.org/3/tv/"
        let midPointSeriesAndSeasonURL = "\(seriesID)" + "?"
        let endPointSeriesAndSeasonURL = ["api_key" : "1f76e7734a01ecc55ff5054b1d2a3e82", "language" : "en-US"]
        
        let seriesAndSeasonURL = URL(string: beginPointSeriesAndSeasonURL + midPointSeriesAndSeasonURL)!.withQueries(endPointSeriesAndSeasonURL)!
        print("Requested Series & Season URL: \(seriesAndSeasonURL)\n")
        
        URLSession.shared.dataTask(with: seriesAndSeasonURL) { (data, response, error) in
            
            if let error = error {
                print("Error with series & season fetch request: \(seriesAndSeasonURL) | \(error) - \(error.localizedDescription)\n")
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
                    let seriesDictionary = try jsonDecoder.decode(Series.self, from: data)
                    
                    if self.checkIfSelected(seriesDictionary: seriesDictionary, isLanguage: self.selectedLanguage) == false {
                        print("Removed non-selected language \(seriesID)")
                        return
                    }
                    
//                    for season in seriesDictionary.seasons {
//                        if season.seasonAirDate == nil {
//                            season.seasonAirDate = ""
//                        }
//                    }
                    
                    self.entireSeries.append(seriesDictionary)
                    
                    print("Name: \(seriesDictionary.name)  Series ID: \(seriesDictionary.ID)  Pilot Air Date: \(seriesDictionary.pilotAirDate ?? "N/A")  Popularity: \(seriesDictionary.popularity)  In Production: \(seriesDictionary.inProduction)  Status: \(seriesDictionary.status)")
                    seriesDictionary.seasons.forEach{ print("Name: \($0.seasonName ?? "N/A")  Number: \($0.seasonNumber ?? 0)  Air Date: \($0.seasonAirDate ?? "N/A")  ID: \($0.ID ?? 0)") } // Commenting this out doesn't require me to initialize SeasonForEpisode or Series???
                    
                    completion(true)
                } catch let error {
                    print("Error handling series & season data: \(seriesAndSeasonURL) | \(error) - \(error.localizedDescription)\n")
                    completion(false) // try searching "r" later
                    return
                }
            }
        }.resume()
    }
    
    // Fetch Season Episode Numbers
    func fetchEpisodes(withSeasonID seasonID: Int, andSeason seasonNumber: Int, completion: @escaping(Bool) -> Void) {
        
        let beginPointEpisodeURL = "https://api.themoviedb.org/3/tv/"
        let midPointEpisodeURL = "\(seasonID)" + "/season/" + "\(seasonNumber)" + "?"
        let endPointEpisodeURL = ["api_key" : "1f76e7734a01ecc55ff5054b1d2a3e82", "language" : "en-US"]
        
        let episodeURL = URL(string: beginPointEpisodeURL + midPointEpisodeURL)!.withQueries(endPointEpisodeURL)!
        print("Requested Episode URL: \(episodeURL)\n")
        
        URLSession.shared.dataTask(with: episodeURL) { (data, response, error) in
            
            if let error = error {
                print("Error with episode fetch request: \(episodeURL) | \(error) - \(error.localizedDescription)"); print("\n")
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
                    let episodes = seasonForEpisodeDictionary.episodes
                    
                    let entireSeries = self.entireSeries
                    for series in entireSeries {
                        for season in series.seasons {
                            if season.ID == seasonForEpisodeDictionary.ID {
                                season.episodes = episodes
                                
                                print("\nSeries Name: \(series.name, series.pilotAirDate ?? "N/A")  Season Number: \(seasonNumber)")
                                episodes.forEach{ print("Name: \($0.episodeName)  Number: \($0.episodeNumber)  Air Date: \($0.episodeAirDate ?? "No Air Date!!!")") }
                            }
                        }
                    }
                    
                    completion(true)
                } catch let error {
                    print("Error handling episode data: \(episodeURL) | \(error) - \(error.localizedDescription)\n")
                    completion(false)
                    return
                }
            }
        }.resume()
    }
    
    func fetchSeriesPoster(forSeries series: Series, completion: @escaping(Bool) -> Void) {
        
        let beginPointPosterURL = "https://image.tmdb.org/t/p/"
        let midPointSizePosterURL = "w500"
        guard let endPointPosterURL = series.posterEndPoint else { return }
        
        let posterURL = URL(string: beginPointPosterURL + midPointSizePosterURL + endPointPosterURL)!
        print(posterURL)
        
        URLSession.shared.dataTask(with: posterURL) { (data, response, error) in
            
            if let error = error {
                print("Error with poster fetch request: \(posterURL) | \(error) - \(error.localizedDescription)"); print("\n")
                completion(false)
                return
            }
            
            if let response = response {
                print("TMDB Poster Response: \(response)\n")
                completion(false)
            }
            
            if let data = data {
                let poster = UIImage(data: data)
                series.posterImage = poster
                completion(true)
            }
        }.resume()
    }
    
    func fetchSeriesPoster1(withSeriesID seriesID: Int, completion: @escaping(Bool) -> Void) {
        
        for series in self.entireSeries {
            if series.ID == seriesID {
                
                let beginPointPosterURL = "https://image.tmdb.org/t/p/"
                let midPointSizePosterURL = "w500"
                guard let endPointPosterURL = series.posterEndPoint else { return }
                
                let posterURL = URL(string: beginPointPosterURL + midPointSizePosterURL + endPointPosterURL)!
                print(posterURL)
                
                URLSession.shared.dataTask(with: posterURL) { (data, response, error) in
                    
                    if let error = error {
                        print("Error with poster fetch request: \(posterURL) | \(error) - \(error.localizedDescription)"); print("\n")
                        completion(false)
                        return
                    }
                    
//                    if let response = response {
//                        print("TMDB Poster Response: \(response)\n")
//                        completion(false)
//                    }
                    
                    if let data = data {
                        let poster = UIImage(data: data)
                        series.posterImage = poster
                        completion(true)
                    }
                }.resume()
            }
        }
    }
    
    func fetchSeriesNetworkLogo(forSeries series: Series, completion: @escaping(Bool) -> Void) {
        
        guard let logoImageEndPoint = series.networks.first?.logoEndPoint else { return }
        
        let beginPointLogoURL = "https://image.tmdb.org/t/p/"
        let midPointSizeLogoURL = "w300"
        let endPointLogoURL = logoImageEndPoint
        
        let logoURL = URL(string: beginPointLogoURL + midPointSizeLogoURL + endPointLogoURL)!
        print(logoURL)
        
        URLSession.shared.dataTask(with: logoURL) { (data, response, error) in
            
            if let error = error {
                print("Error with logo fetch request: \(logoURL) | \(error) - \(error.localizedDescription)"); print("\n")
                completion(false)
                return
            }
            
//            if let response = response {
//                print("TMDB Logo Response: \(response)\n")
//                completion(false)
//            }
            
            if let data = data {
                let logo = UIImage(data: data)
                series.logoImage = logo
                completion(true)
            }
        }.resume()
    }
    
    func checkIfSelected(seriesDictionary series: Series, isLanguage selectedLanguage: String) -> Bool {
        for language in series.languages {
            if language == selectedLanguage {
                return true
            }
        }
        return false
    }
}


// MARK: - URL Query Extention
extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.compactMap{ URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}
