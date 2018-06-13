//
//  Episode.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 4/26/18.
//  Copyright © 2018 UnInfamous Games. All rights reserved.
//

import Foundation

// Based on https://api.themoviedb.org/3/tv/37680/season/1?api_key=1f76e7734a01ecc55ff5054b1d2a3e82&language=en-US

struct SeasonForEpisode: Decodable {
    let episodes: [Episode]
//
//    enum CodingKeys: String, CodingKey {
//        case episodes
//    }
}

class Episode: Decodable {
    var seasonID: Int
    let episodeName: String
    let episodeNumber: Int
    var episodeAirDate: String?
    let episodeOverview: String
    
    enum CodingKeys: String, CodingKey {
        case seasonID = "id"
        case episodeName = "name"
        case episodeNumber = "episode_number"
        case episodeAirDate = "air_date"
        case episodeOverview = "overview"
    }
    
    init(seasonID: Int, episodeName: String, episodeNumber: Int, episodeAirDate: String?, episodeOverview: String) {
        self.seasonID = seasonID
        self.episodeName = episodeName
        self.episodeNumber = episodeNumber
        self.episodeAirDate = episodeAirDate
        self.episodeOverview = episodeOverview
    }
    
    static func ==(lhs: Episode, rhs: Episode) -> Bool {
        return lhs.episodeName == rhs.episodeName && lhs.episodeNumber == rhs.episodeNumber && lhs.episodeAirDate == rhs.episodeAirDate && lhs.episodeOverview == rhs.episodeOverview
    }
}

