//
//  Season.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 4/26/18.
//  Copyright © 2018 UnInfamous Games. All rights reserved.
//

import Foundation

// Based on https://api.themoviedb.org/3/tv/37680?api_key=9d94523b28ef0a99fe43078ea391db1c&language=en-US

struct Series: Decodable {
    let seasons: [SeasonArray]
    
    enum CodingKeys: String, CodingKey {
        case seasons
    }
}

struct SeasonArray: Decodable {
    let seasonNumber: Int
    let seasonAirDate: String?
    
    enum CodingKeys: String, CodingKey {
        case seasonNumber = "season_number"
        case seasonAirDate = "air_date"
    }
}
