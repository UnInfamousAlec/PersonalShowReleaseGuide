//
//  Artwork.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 6/21/18.
//  Copyright © 2018 Smart Alec Apps. All rights reserved.
//

import UIKit

struct ArtworkResults: Decodable {
    let results: [Artwork]
}

class Artwork: Decodable {
    let posterEndPoint: String?
    var posterImage: UIImage?
    let releaseDate: String?
    let popularity: Double
    
    enum CodingKeys: String, CodingKey {
        case posterEndPoint = "poster_path"
        case releaseDate = "release_date"
        case popularity
    }
    
    init(posterEndPoint: String?, releaseDate: String?, popularity: Double) {
        self.posterEndPoint = posterEndPoint
        self.releaseDate = releaseDate
        self.popularity = popularity
    }
}
