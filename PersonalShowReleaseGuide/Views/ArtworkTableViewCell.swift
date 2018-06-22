//
//  ArtworkTableViewCell.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 6/20/18.
//  Copyright © 2018 Smart Alec Apps. All rights reserved.
//

import UIKit

class ArtworkTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var artworkPosterImageView: UIImageView!
    
    
    // MARK: - Properties
    var artwork: Artwork? {
        didSet {
            updatePosters()
        }
    }
    
    
    // MARK: - Methods
    func updatePosters() {
        guard let artwork = artwork else { return }
        
        artworkPosterImageView.image = artwork.posterImage
    }
}
