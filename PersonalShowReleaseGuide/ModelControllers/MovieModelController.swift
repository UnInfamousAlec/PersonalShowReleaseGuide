//
//  MovieModelController.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 6/12/18.
//  Copyright © 2018 UnInfamous Games. All rights reserved.
//

import UIKit

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
        print("\nMovie Search URL: \(movieURL)")
        
        URLSession.shared.dataTask(with: movieURL) { (data, response, error) in
            
            if let error = error {
                print("Error fetching Movie: \(movieURL) | \(error)")
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
    
    func fetchPoster(completion: @escaping(Bool) -> Void) {
        
        for movie in self.movies {
            
            guard let endURL = movie.posterEndPoint else {
                movie.posterImage = #imageLiteral(resourceName: "ImageNotAvailable")
                continue
                
            }
            
            let baseURL = "https://image.tmdb.org/t/p/"
            let midURL = "w500"
            
            let moviePosterURL = URL(string: baseURL + midURL + endURL)!
            print(moviePosterURL)
            
            URLSession.shared.dataTask(with: moviePosterURL) { (data, response, error) in
                
                if let error = error {
                    print("Error fetching movie poster: \(error) - \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
//                if let response = response {
//                    print("TMDB Response: \(moviePosterURL) | \(response)")
//                    completion(false)
//                }
            
                if let data = data {
                    let poster = UIImage(data: data)
                    movie.posterImage = poster
                    completion(true)
                }
            }.resume()
        }
    }
}
