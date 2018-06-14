//
//  Movie.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 6/12/18.
//  Copyright © 2018 UnInfamous Games. All rights reserved.
//

import Foundation

// Based on https://api.themoviedb.org/3/search/movie?api_key=1f76e7734a01ecc55ff5054b1d2a3e82&language=en-US&query=deadpool
struct MovieResults: Decodable {
    let results: [Movie]
}

struct Movie: Decodable {
    let ID: Int
    let name: String
    let poster: String?
    let language: String
    let adult: Bool
    let overview: String
    let releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case ID = "id"
        case name = "title"
        case poster = "poster_path"
        case language = "original_language"
        case adult
        case overview
        case releaseDate = "release_date"
    }
}
