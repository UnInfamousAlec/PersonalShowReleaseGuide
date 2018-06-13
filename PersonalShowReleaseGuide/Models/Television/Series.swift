//
//  Series.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 4/26/18.
//  Copyright © 2018 UnInfamous Games. All rights reserved.
//

import Foundation

// Based on https://api.themoviedb.org/3/search/tv?api_key=1f76e7734a01ecc55ff5054b1d2a3e82&query=suits&language=en-US

struct SeriesResults: Decodable {
    let results: [Series]
    
}

struct Series: Decodable {
    let ID: Int
    let name: String // Don't think I need this
    let pilotAirDate: String? // Don't think I need this  Might have issues with this
    let language: String // Don't think I need this
    let overview: String // Don't think I need this
    let voteCount: Int // Don't think I need this
    let voteAverage: Double // Don't think I need this
    let posterEndPoint: String? // Don't think I need this
    var seriesForSeason: [SeriesForSeason]?

    
    enum CodingKeys: String, CodingKey {
        case ID = "id"
        case name
        case pilotAirDate = "first_air_date"
        case language = "original_language"
        case overview
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case posterEndPoint = "poster_path"
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
