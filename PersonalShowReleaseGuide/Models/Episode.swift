//
//  Episode.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 4/26/18.
//  Copyright © 2018 UnInfamous Games. All rights reserved.
//

import Foundation

// Based on https://api.themoviedb.org/3/tv/37680/season/1?api_key=1f76e7734a01ecc55ff5054b1d2a3e82&language=en-US

struct SeasonForEpisode {
    let episodes: [Episode]
    
    enum CodingKeys: String, CodingKey {
        case episodes
    }
}

struct Episode: Decodable {
    let episodeNumber: Int
    let name: String
    let overview: String
    let airDate: String
    
    enum CodingKeys: String, CodingKey {
        case episodeNumber = "episode_number"
        case name
        case overview
        case airDate = "air_date"
    }
}

