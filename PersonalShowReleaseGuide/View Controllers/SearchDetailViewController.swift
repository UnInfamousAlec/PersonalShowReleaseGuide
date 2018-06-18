//
//  SearchDetailViewController.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 6/12/18.
//  Copyright © 2018 UnInfamous Games. All rights reserved.
//

import UIKit

class SearchDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var seasonAndEpisodeTableView: UITableView!
    
    @IBOutlet weak var seriesPosterImageView: UIImageView!
    @IBOutlet weak var seriesNameLabel: UILabel!
    @IBOutlet weak var seriesAirYearLabel: UILabel!
    
    @IBOutlet weak var seasonCountLabel: UILabel!
    @IBOutlet weak var episodeCountLabel: UILabel!
    
    @IBOutlet weak var seriesOverviewLabel: UILabel!
    @IBOutlet weak var seriesStatusLabel: UILabel!
    
    @IBOutlet weak var seriesNetworkLabel: UILabel!
    @IBOutlet weak var seriesNetworkLogoImageView: UIImageView!
    
    @IBOutlet weak var addToWatchlistButton: UIButton!
    
    
    // MARK: - Properties
    var series: Series?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.hidesBarsOnSwipe = false
        seasonAndEpisodeTableView.dataSource = self
        seasonAndEpisodeTableView.delegate = self
        
        addToWatchlistButton.isHidden = true
        
        fetchSeriesImages()
        updateSeries()
    }
    
    
    // MARK: - Datasource Methods
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return series?.seasonCount ?? 1 // Fix later
//    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 125
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let series = series else { return 0 }
        let season = drillToSeason(with: series)
        guard let episodes = season.episodes else { return 0 }
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath) as? EpisodeTableViewCell else { return UITableViewCell() }
        guard let series = series else { return UITableViewCell() }
        let season = self.drillToSeason(with: series)
        guard let episodes = season.episodes else { return UITableViewCell() }
        cell.episode = episodes[indexPath.row]
        return cell
    }
    
    // MARK: - Methods
    func updateSeries() {
        guard let series = series else { return }
        
        seriesNameLabel.text = String(series.name)
        seriesAirYearLabel.text = series.pilotAirDate
        seasonCountLabel.text = String(series.seasonCount)
        episodeCountLabel.text = String(series.episodeCount)
        seriesStatusLabel.text = series.status
        seriesOverviewLabel.text = series.overview
        seriesNetworkLabel.text = series.networks.map{$0.name}.first
    }
    
    func fetchSeriesImages() {
        guard let series = series else { return }
        TelevisionModelController.shared.fetchSeriesPoster(forSeries: series) { (success) in
            DispatchQueue.main.async {
                if success {
                    self.seriesPosterImageView.image = series.posterImage
                }
                
                if !success {
                    print("Error fetching Poster")
                }
            }
        }
        
        TelevisionModelController.shared.fetchSeriesNetworkLogo(forSeries: series) { (success) in
            DispatchQueue.main.async {
                if success {
                    self.seriesNetworkLogoImageView.image = series.logoImage
                }
                
                if !success {
                    print("Error fetching Logo")
                }
            }
        }
    }
    
    func drillToSeason(with series: Series) -> Season {
        let seasons = series.seasons
        let seasonNumber = DateLogicController.shared.findMostCurrentSeason(seriesID: series.ID)
        
        for season in seasons {
            guard let number = season.seasonNumber else { continue }
            if number == seasonNumber {
                return season
            }
        }
        return seasons.last! //FIXME
    }
    
    
    // MARK: - Actions
    @IBAction func addToWatchlistButtonTapped(_ sender: UIButton) {
        
    }
}
