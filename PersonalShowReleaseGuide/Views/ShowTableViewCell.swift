//
//  ShowTableViewCell.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 4/26/18.
//  Copyright © 2018 UnInfamous Games. All rights reserved.
//

import UIKit

class ShowTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var showTitleLabel: UILabel!
    @IBOutlet weak var showCurrentSeasonLabel: UILabel!
    @IBOutlet weak var showNextEpisodeLabel: UILabel!
    @IBOutlet weak var showTest: UILabel!
    @IBOutlet weak var showNextEpisodeAirDateLabel: UILabel!
    

    // MARK: - Properties
    var show: Show? {
        didSet {
            showAirYear()
        }
    }
    
    var season: SeasonArray? {
        didSet {
            showSeasonNumber()
        }
    }
    
    
    // MARK: - Methods
    func showAirYear() {
        
        guard let show = show else { return }
        var year = ""
        var showAirYear = ""
        
        for letter in show.pilotAirDate {
            if letter == "-" {
                break
            }
            year.append(letter)
        }
        
        if year.count > 0 {
            showAirYear = " (\(year))"
        } else {
            showAirYear = ""
        }
        
        self.showTitleLabel.text = "\(show.title)\(showAirYear)"
    }
    
    func showSeasonNumber() {
        
//        guard let season = season else { return }
        
//        let seasonNumberAndAirDates = DateLogic.shared.findClosestEpisodeDate()
//
//        self.showCurrentSeasonLabel.text = "\(seasonNumber)"
        
    }
}
