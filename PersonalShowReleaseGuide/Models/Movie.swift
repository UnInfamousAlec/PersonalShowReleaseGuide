//
//  Movie.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 6/12/18.
//  Copyright © 2018 UnInfamous Games. All rights reserved.
//

import UIKit

// Based on https://api.themoviedb.org/3/search/movie?api_key=1f76e7734a01ecc55ff5054b1d2a3e82&language=en-US&query=deadpool&page=1
struct MovieResults: Decodable {
    let results: [Movie]
}

class Movie: Decodable {
    let ID: Int
    let name: String
    let posterEndPoint: String?
    var posterImage: UIImage?
    let language: String
    let isAdult: Bool
    let overview: String
    let releaseDate: String
    let popularity: Double
    
    enum CodingKeys: String, CodingKey {
        case ID = "id"
        case name = "title"
        case posterEndPoint = "poster_path"
        case language = "original_language"
        case isAdult = "adult"
        case overview
        case releaseDate = "release_date"
        case popularity
    }
    
//    init(ID: Int, name: String, language: String, isAdult: Bool, overview: String, releaseDate: String, popularity: Double) {
//        self.ID = ID
//        self.name = name
//        self.language = language
//        self.isAdult = isAdult
//        self.overview = overview
//        self.releaseDate = releaseDate
//        self.popularity = popularity
//    }
}
