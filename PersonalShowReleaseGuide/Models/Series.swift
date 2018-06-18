//
//  Season.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 4/26/18.
//  Copyright © 2018 UnInfamous Games. All rights reserved.
//

import UIKit

// Based on https://api.themoviedb.org/3/search/tv?api_key=1f76e7734a01ecc55ff5054b1d2a3e82&query=suits&language=en-US
struct SearchedDictionary: Decodable {
    let results: [SeriesResults]
}

struct SeriesResults: Decodable {
    let ID: Int
    var series: [Series]?
    
    enum CodingKeys: String, CodingKey {
        case ID = "id"
    }
}

// Based on https://api.themoviedb.org/3/tv/37680?api_key=1f76e7734a01ecc55ff5054b1d2a3e82&language=en-US
class Series: Decodable {                   // Show on Detail?
    let ID: Int                             // NO
    let name: String                        // YES | Left
    let languages: [String]                 // No
    var pilotAirDate: String?               // Yes or (Unknown) | Left
    let seasonCount: Int                    // Yes | Left
    let episodeCount: Int                   // Yes | Left
    let popularity: Double                  // No
    let posterEndPoint: String?             // Yes or stock | Left
    var posterImage: UIImage?
    var logoImage: UIImage?
    let overview: String                    // YES | Left
    let inProduction: Bool                  // Maybe?
    let status: String                      // YES | Left
    var seasons: [Season]                   // YES |
    let networks: [Network]                 // Yes |
    
    enum CodingKeys: String, CodingKey {
        case ID = "id"
        case name = "original_name"
        case languages
        case pilotAirDate = "first_air_date"
        case seasonCount = "number_of_seasons"
        case episodeCount = "number_of_episodes"
        case popularity
        case posterEndPoint = "poster_path"
        case overview
        case inProduction = "in_production"
        case status
        case seasons
        case networks
    }
    
//    init(ID: Int, name: String, languages: [String], pilotAirDate: String, popularity: Double, posterEndPoint: String?, overview: String, inProduction: Bool, status: String, seasons: [Season], networks: [Network]) {
//        self.ID = ID
//        self.name = name
//        self.languages = languages
//        self.pilotAirDate = pilotAirDate
//        self.popularity = popularity
//        self.posterEndPoint = posterEndPoint
//        self.overview = overview
//        self.inProduction = inProduction
//        self.status = status
//        self.seasons = seasons
//        self.networks = networks
//    }
}

class Season: Decodable {
    var ID: Int?                            // NO
    var seasonName: String?                 // Maybe?
    var seasonNumber: Int?                  // YES | Right in section
    var seasonAirDate: String?              // Yes
    var episodes: [Episode]?                // YES |
    
    enum CodingKeys: String, CodingKey {
        case ID = "id"
        case seasonName = "name"
        case seasonNumber = "season_number"
        case seasonAirDate = "air_date"
        case episodes
    }
}

class Network: Decodable {
    let name: String                        // Yes, If no Logo | Left
    let logoEndPoint: String?               // Yes if present | Left
    
    enum CodingKeys: String, CodingKey {
        case name
        case logoEndPoint = "logo_path"
    }
    
    init(name: String, logoEndPoint: String) {
        self.name = name
        self.logoEndPoint = logoEndPoint
    }
}

// Based on https://api.themoviedb.org/3/tv/37680/season/1?api_key=1f76e7734a01ecc55ff5054b1d2a3e82&language=en-US
class SeasonForEpisode: Decodable {
    let ID: Int                             // NO
    let episodes: [Episode]                 // YES |
    
    enum CodingKeys: String, CodingKey {
        case ID = "id"
        case episodes
    }
    
    init(ID: Int, episodes: [Episode]) {
        self.ID = ID
        self.episodes = episodes
    }
}

class Episode: Decodable {
    let episodeName: String                 // Yes | Right
    let episodeNumber: Int                  // YES | Right
    var episodeAirDate: String?             // YES | Right
    let episodeOverview: String //Optional? // Yes?
    
    enum CodingKeys: String, CodingKey {
        case episodeName = "name"
        case episodeNumber = "episode_number"
        case episodeAirDate = "air_date"
        case episodeOverview = "overview"
    }
    
    init(episodeName: String, episodeNumber: Int, episodeAirDate: String?, episodeOverview: String) {
        self.episodeName = episodeName
        self.episodeNumber = episodeNumber
        self.episodeAirDate = episodeAirDate
        self.episodeOverview = episodeOverview
    }
}
