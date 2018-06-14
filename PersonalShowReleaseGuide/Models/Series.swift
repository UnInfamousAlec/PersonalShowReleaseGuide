//
//  Season.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 4/26/18.
//  Copyright © 2018 UnInfamous Games. All rights reserved.
//

import Foundation

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
class Series: Decodable {
    let ID: Int
    let name: String
    let languages: [String]
    var pilotAirDate: String?
    let popularity: Double
    let posterEndPoint: String?
    let overview: String
    let inProduction: Bool
    let status: String
    var seasons: [Season]
    let networks: [Network]
    
    enum CodingKeys: String, CodingKey {
        case ID = "id"
        case name = "original_name"
        case languages
        case pilotAirDate = "first_air_date"
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
    var ID: Int?
    var seasonName: String?
    var seasonNumber: Int?
    var seasonAirDate: String?
    var episodes: [Episode]?
    
    enum CodingKeys: String, CodingKey {
        case ID = "id"
        case seasonName = "name"
        case seasonNumber = "season_number"
        case seasonAirDate = "air_date"
        case episodes
    }
}

class Network: Decodable {
    let name: String
    let logoEndPoint: String?
    
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
    let ID: Int
    let episodes: [Episode]
    
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
    let episodeName: String
    let episodeNumber: Int
    var episodeAirDate: String?
    let episodeOverview: String
    
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
