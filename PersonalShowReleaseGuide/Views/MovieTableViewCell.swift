//
//  MovieTableViewCell.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 6/7/18.
//  Copyright © 2018 UnInfamous Games. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieAirDateLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    
    
    // MARK: - Properties
    var movie: Movie? {
        didSet {
            updateMovie()
        }
    }
    
    
    // MARK: - Methods
    func updateMovie() {
        guard let movie = movie else { return }
        
        moviePosterImageView.image = movie.posterImage
        movieNameLabel.text = movie.name
        movieAirDateLabel.text = movie.releaseDate
        movieOverviewLabel.text = movie.overview
    }
}
