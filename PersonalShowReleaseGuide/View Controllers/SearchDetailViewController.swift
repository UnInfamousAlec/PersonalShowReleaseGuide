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
    
    @IBOutlet weak var seasonCountLabel: UILabel!
    @IBOutlet weak var episodeCountLabel: UILabel!
    @IBOutlet weak var seriesAirYearLabel: UILabel!
    
    @IBOutlet weak var seriesOverviewTextView: UITextView!
    @IBOutlet weak var seriesStatusLabel: UILabel!
    
    @IBOutlet weak var seriesNetworkLabel: UILabel!
    @IBOutlet weak var seriesNetworkLogoImageView: UIImageView!
    
    @IBOutlet weak var addToWatchlistButton: UIButton!
    
    
    // MARK: - Properties
    let seriesDateFormat = "MMM dd, YYYY"
//    let episodeDateFormat = "MMM dd, YYYY"
    var series: Series?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.hidesBarsOnSwipe = false
        seasonAndEpisodeTableView.dataSource = self
        seasonAndEpisodeTableView.delegate = self
        
        addToWatchlistButton.isHidden = true
        
        fetchSeriesImages()
        
        seriesOverviewTextView.flashScrollIndicators()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateSeries()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let point = CGPoint(x: 0, y: 8)
        self.seriesOverviewTextView.setContentOffset(.zero, animated: false)
        self.seriesOverviewTextView.setContentOffset(point, animated: true)
    }
    
    
//     MARK: - Datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
//        return series?.seasonCount ?? 1 // This was putting all sections out duplicating the episodes for as many seasons as there were.
        return 1
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 125
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let series = series else { return 0 }
        let season = drillToSeason(with: series)
        guard let episodes = season.episodes else { return 0 }
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // This is adding more episodes when scrolling happens
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell", for: indexPath) as? EpisodeTableViewCell else { return UITableViewCell() }
        guard let series = series else { return UITableViewCell() }
        let season = self.drillToSeason(with: series)
        guard let episodes = season.episodes else { return UITableViewCell() }
        cell.episode = episodes[indexPath.row]
        return cell
    }
    
    // MARK: - Methods
    func updateSeries() {
        guard let series = series else { return }
        guard let pilotAirDate = series.pilotAirDate else { return }
        guard let formattedPilotAirDate = DateLogicController.shared.formatAirDate(withFormat: seriesDateFormat, forDate: pilotAirDate) else { return }
        
        seriesPosterImageView.image = series.posterImage
        seriesNameLabel.text = String(series.name)
        seriesAirYearLabel.text = formattedPilotAirDate
        seasonCountLabel.text = String(series.seasonCount)
        episodeCountLabel.text = String(series.episodeCount)
        seriesStatusLabel.text = series.status
        seriesOverviewTextView.text = series.overview
        seriesNetworkLabel.text = series.networks.map{$0.name}.first
    }
    
    func fetchSeriesImages() {
        guard let series = series else { return }
//        TelevisionModelController.shared.fetchSeriesPoster(forSeries: series) { (success) in
//            DispatchQueue.main.async {
//                if success {
//                    self.seriesPosterImageView.image = series.posterImage
//                }
//
//                if !success {
//                    print("Error fetching Poster")
//                }
//            }
//        }
        
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
