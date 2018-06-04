//
//  Show.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 4/26/18.
//  Copyright © 2018 UnInfamous Games. All rights reserved.
//

import Foundation

// Based on https://api.themoviedb.org/3/search/tv?api_key=9d94523b28ef0a99fe43078ea391db1c&query=suits&language=en-US

struct ShowResults: Decodable {
    let results: [Show]
}

struct Show: Decodable {
    let title: String
    let id: Int
    let pilotAirDate: String
    
    enum CodingKeys: String, CodingKey {
        case title = "original_name"
        case id
        case pilotAirDate = "first_air_date"
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
