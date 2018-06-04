//
//  Episode.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 4/26/18.
//  Copyright © 2018 UnInfamous Games. All rights reserved.
//

import Foundation

// Based on https://api.themoviedb.org/3/tv/37680/season/1?api_key=9d94523b28ef0a99fe43078ea391db1c&language=en-US

struct Season {
    let episodes: [Episode]
    
    enum CodingKeys: String, CodingKey {
        case episodes
    }
}

struct Episode: Decodable {
    let episodeNumber: Int
    let airDate: String
    
    enum CodingKeys: String, CodingKey {
        case episodeNumber = "episode_number"
        case airDate = "air_date"
    }
}

