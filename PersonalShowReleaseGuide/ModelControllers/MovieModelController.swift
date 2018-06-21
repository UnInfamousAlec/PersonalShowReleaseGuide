//
//  MovieModelController.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 6/12/18.
//  Copyright © 2018 UnInfamous Games. All rights reserved.
//

import Foundation

class MovieModelController {
    
    // MARK: - Shared instance
    static let shared = MovieModelController()
    
    
    // MARK: - Properties
    var selectedLanguage = "en"
    var selectedCountry = "US"
    var adultContent = false
    var pageNumber = 1
    var movies = [Movie]()
    
    
    // MARK: - Methods
    func fetchMovies(searchTerm: String, completion: @escaping(Bool) -> Void) {
        
        let baseURL = URL(string: "https://api.themoviedb.org/3/search/movie?")!
        let queries = ["query" : searchTerm, "api_key" : "1f76e7734a01ecc55ff5054b1d2a3e82", "language" : "\(self.selectedLanguage)-\(self.selectedCountry)", "include_adult" : "\(adultContent)" , "page" : "\(pageNumber)"]
        
        let movieURL = baseURL.withQueries(queries)!
        print("Movie Search URL: \(movieURL)")
        
        URLSession.shared.dataTask(with: movieURL) { (data, response, error) in
            
            if let error = error {
                print("Error fetching Movie: \(searchTerm) | \(error)")
                completion(false)
                return
            }
            
            if let response = response {
                print("TMDB Response: \(response)")
                completion(false)
            }
            
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let movieDictionary = try jsonDecoder.decode(MovieResults.self, from: data)
                    let movies = movieDictionary.results.compactMap( {$0} )
                    
                    for movie in movies {
                        self.movies.append(movie)
                    }
                    
                    completion(true)
                } catch let error {
                    print("Error decoding data: \(searchTerm) | \(error) - \(error.localizedDescription)")
                    completion(false)
                    return
                }
            }
        }.resume()
    }
}
