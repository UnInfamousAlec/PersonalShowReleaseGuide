//
//  Season.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 4/26/18.
//  Copyright © 2018 UnInfamous Games. All rights reserved.
//

import Foundation

// Based on https://api.themoviedb.org/3/tv/37680?api_key=1f76e7734a01ecc55ff5054b1d2a3e82&language=en-US

struct SeriesForSeason: Decodable {
    let seasonIDFromSeries: Int
    let nameOfSeason: String
    let inProduction: Bool
    let status: String
    let seasons: [Season]
    
    enum CodingKeys: String, CodingKey {
        case seasonIDFromSeries = "id"
        case nameOfSeason = "original_name"
        case inProduction = "in_production"
        case status
        case seasons
    }
}

class Season: Decodable {
    var seasonName: String?
    var seasonNumber: Int?
    var seasonAirDate: String?
    
    enum CodingKeys: String, CodingKey {
        case seasonName = "name"
        case seasonNumber = "season_number"
        case seasonAirDate = "air_date"
    }
}
