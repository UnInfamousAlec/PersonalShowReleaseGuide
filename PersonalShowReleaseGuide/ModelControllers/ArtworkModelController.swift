//
//  ArtworkModelController.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 6/20/18.
//  Copyright © 2018 Smart Alec Apps. All rights reserved.
//

import UIKit

class ArtworkModelController {
    
    // MARK: - Instance
    static let shared = ArtworkModelController()
    
    
    // MARK: - Propeties
    let selectedLanguage = "en"
    let selectedCountry = "US"
    let selectedRegion = "" // Add later
    var seriesPosters = [Artwork]()
    var moviePosters = [Artwork]()
    
    
    // MARK: - Methods
    func fetchPopularOrUpcomingPosters(forContentType type: String, completion: @escaping(Bool) -> Void) {
        
        let baseArtworkURL = URL(string: "https://api.themoviedb.org/3/\(type)?")!
        let queries = ["api_key" : "1f76e7734a01ecc55ff5054b1d2a3e82", "language" : "\(self.selectedLanguage)-\(self.selectedCountry)"]
        
        let popularOrUpcomingURL = baseArtworkURL.withQueries(queries)!
        print("\nPoster Search URL: \(popularOrUpcomingURL)")
        
        URLSession.shared.dataTask(with: popularOrUpcomingURL) { (data, response, error) in
            
            if let error = error {
                print("Error fetching Poster: \(popularOrUpcomingURL) | \(error)")
                completion(false)
                return
            }
            
            //            if let response = response {
            //                print("\nTMDB Response: \(movieURL) | \(response)")
            //                completion(false)
            //            }
            
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let resultsDictionary = try jsonDecoder.decode(ArtworkResults.self, from: data)
                    let artworks = resultsDictionary.results.compactMap( {$0} )
                    
                    if type == "tv/popular" {
                        let popularSeriesPosters = artworks
                        self.seriesPosters = popularSeriesPosters
                        completion(true)
                    } else if type == "movie/upcoming" {
                        let upcomingMoviePosters = artworks
                        self.moviePosters = upcomingMoviePosters
                        completion(true)
                    }
                } catch let error {
                    print("Error decoding data: \(popularOrUpcomingURL) | \(error) - \(error.localizedDescription)")
                    completion(false)
                    return
                }
            }
        }.resume()
    }
    
    func fetchPosterImages(forShow show: Artwork, completion: @escaping(Bool) -> Void) {
        
        let basePosterURL = "https://image.tmdb.org/t/p/original"
        guard let imageEndPoint = show.posterEndPoint else { return }
        
        let popularOrUpcomingPosterURL = URL(string: basePosterURL + imageEndPoint)!
        print("Poster Image URL: \(popularOrUpcomingPosterURL)")
        
        URLSession.shared.dataTask(with: popularOrUpcomingPosterURL) { (data, response, error) in
            
            if let error = error {
                print("❌ Error fetching artwork poster: \(popularOrUpcomingPosterURL) | \(error) - \(error.localizedDescription)")
                completion(false)
                return
            }
            
//            if let response = response {
//                print("TMDB Response: \(response)")
//                completion(false)
//            }
            
            if let data = data {
                let image = UIImage(data: data)
                show.posterImage = image
                completion(true)
            }
        }.resume()
    }
}
