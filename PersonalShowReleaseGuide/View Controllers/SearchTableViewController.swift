//
//  SearchTableViewController.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 4/26/18.
//  Copyright © 2018 UnInfamous Games. All rights reserved.
//

import UIKit

class SearchTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    static let shared = SearchTableViewController()

    // MARK: - Outlets
    @IBOutlet weak var showTableView: UITableView!
    @IBOutlet weak var showSearchBar: UISearchBar!
    @IBOutlet weak var showSegmentedControl: UISegmentedControl!
    
    
    // MARK: - Properties
    var hasSearched = false
    var seriesIDsUsed = [Int]()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showTableView.dataSource = self
        showTableView.delegate = self
        showSearchBar.delegate = self
        
        DateLogicController.shared.currentDate()
        showSegmentedControl.layer.cornerRadius = 0
        showSegmentedControl.layer.borderWidth = 1
        
        navigationController?.hidesBarsOnSwipe = true // Not working now that it's a view controller
        showTableView.keyboardDismissMode = .onDrag
        
        fetchArtwork()
    }
    
    
    // MARK: - Methods
    func fetchArtwork() {
        if showSegmentedControl.selectedSegmentIndex == 0 {
            ArtworkModelController.shared.fetchPopularOrUpcomingPosters(forContentType: "tv/popular") { (success) in
                
                if success {
                    let seriesArtwork = ArtworkModelController.shared.seriesPosters
                    
                    for series in seriesArtwork {
                        ArtworkModelController.shared.fetchPosterImages(forShow: series, completion: { (success) in
                            
                            if success {
                                DispatchQueue.main.async {
                                    ArtworkModelController.shared.seriesPosters.sort(by: {$0.popularity > $1.popularity} )
                                    //                                ArtworkModelController.shared.seriesPosters.forEach{ print($0.posterEndPoint ?? "", $0.popularity) }
                                    self.showTableView.reloadData()
                                }
                            }
                            
                            if !success {
                                print("Error fetching series artwork posters")
                            }
                        })
                    }
                }
                
                if !success {
                    print("Error fetching series artwork")
                }
            }
        } else if showSegmentedControl.selectedSegmentIndex == 1 {
            ArtworkModelController.shared.fetchPopularOrUpcomingPosters(forContentType: "movie/upcoming") { (success) in
                
                if success {
                    let movieArtwork = ArtworkModelController.shared.moviePosters
                    
                    for movie in movieArtwork {
                        ArtworkModelController.shared.fetchPosterImages(forShow: movie, completion: { (success) in
                            
                            if success {
                                DispatchQueue.main.async {
                                    ArtworkModelController.shared.moviePosters.sort(by: {$0.popularity > $1.popularity} )
                                    //                                ArtworkModelController.shared.moviePosters.forEach{ print($0.posterEndPoint ?? "", $0.popularity) }
                                    self.showTableView.reloadData()
                                }
                            }
                            
                            if !success {
                                print("Error getching movie artwork posters")
                            }
                        })
                    }
                }
                
                if !success {
                    print("Error fetching movies artwork")
                }
            }
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchTerm = searchBar.text, searchTerm.count > 0 else { return }
        
        searchBar.resignFirstResponder()
        self.hasSearched = true
        
        if showSegmentedControl.selectedSegmentIndex == 0 {
            print(ArtworkModelController.shared.seriesPosters.count)
            print(ArtworkModelController.shared.moviePosters.count)
            print(TelevisionModelController.shared.entireSeries.count)
            print(MovieModelController.shared.movies.count)
            
            self.clearDataFromSeries()
            self.clearDataFromMovies()
            self.clearDataFromSeriesArtwork()
            self.clearDataFromMoviesArtwork()
            
            fetchSeries(withSearchTerm: searchTerm)
            
        } else if showSegmentedControl.selectedSegmentIndex == 1 {
            self.clearDataFromMovies()
            self.clearDataFromMoviesArtwork()
            fetchMovies(withSearchTerm: searchTerm)
        }
        
        searchBar.text = ""
    }
    
    func fetchSeries(withSearchTerm searchTerm: String) {
        TelevisionModelController.shared.fetchSeriesIDs(by: searchTerm) { (success) in
            
            if success {
                let seriesIDs = TelevisionModelController.shared.seriesIDs
                for seriesID in seriesIDs {
                    
                    TelevisionModelController.shared.fetchSeriesAndSeasons(withSeriesID: seriesID, completion: { (success) in
                        
                        if success {
                            let seasonNumber = DateLogicController.shared.findMostCurrentSeason(seriesID: seriesID)
                            
                            if seasonNumber == -1 {
                                self.seriesIDsUsed.append(seriesID)
                                return
                            }
                            
                            TelevisionModelController.shared.fetchSeriesPoster1(withSeriesID: seriesID, completion: { (success) in
                                if !success {
                                    print("Unable to fetch Poster1 for: \(seriesID)")
                                }
                            })
                            
                            TelevisionModelController.shared.fetchEpisodes(withSeasonID: seriesID, andSeason: seasonNumber, completion: { (success) in
                                
                                if success {
                                    self.seriesIDsUsed.append(seriesID)
                                    
                                    if self.seriesIDsUsed.count == TelevisionModelController.shared.entireSeries.count {
                                        
                                        DispatchQueue.main.async {
                                            TelevisionModelController.shared.entireSeries.sort(by: {$0.popularity > $1.popularity} )
//                                            TelevisionModelController.shared.entireSeries.forEach{ print($0.name, $0.popularity) }
                                            self.showTableView.reloadData()
                                        }
                                    }
                                }
                                
                                if !success {
                                    print("Error fetching episodes)")
                                }
                            })
                        }
                        
                        if !success { //Erroring out
                            self.networkAlert()
                            print("Error fetching seasons)")
                        }
                    })
                }
                
                if !success {
                    self.networkAlert()
                    print("Error fetching shows)")
                }
            }
        }
    }
    
    func fetchMovies(withSearchTerm searchTerm: String) {
        MovieModelController.shared.fetchMovies(searchTerm: searchTerm) { (success) in
            if success {
                
                MovieModelController.shared.fetchPoster(completion: { (success) in
                    
                    if success {
                        
                        DispatchQueue.main.async {
                            MovieModelController.shared.movies.sort(by: {$0.releaseDate > $1.releaseDate})
//                            MovieModelController.shared.movies.forEach{ print($0.name, $0.releaseDate) }
                            self.showTableView.reloadData()
                        }
                    }
                    
                    if !success {
                        self.networkAlert()
                        print("Error fetching movie posters: \(Error.self)")
                    }
                })
            }
            
            if !success {
                self.networkAlert()
                print("Error fetching movies: \(Error.self)")
            }
        }
    }
    
    func networkAlert() {
        let alertController = UIAlertController(title: "Network Error", message: "Please check your network connection and try again", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) in
            
            guard let settingsURL = URL(string: "App-Prefs:root") else { return }
            
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL, completionHandler: nil)
            }
        }
        
        alertController.addAction(dismissAction)
        alertController.addAction(settingsAction)
        present(alertController, animated: true)
    }
    
    func clearDataFromSeriesArtwork() {
        let seriesRows = ArtworkModelController.shared.seriesPosters.count
        ArtworkModelController.shared.seriesPosters.removeAll()
        if seriesRows == 0 {
            return
        } else {
            showTableView.deleteRows(at: (0..<seriesRows).map({ (row) in IndexPath(row: row, section: 0)}), with: .automatic)
            self.showTableView.setContentOffset(.zero, animated: true)
        }
    }
    
    func clearDataFromMoviesArtwork() {
        let moviesRows = ArtworkModelController.shared.moviePosters.count
        ArtworkModelController.shared.moviePosters.removeAll()
        if moviesRows == 0 {
            return
        } else {
            showTableView.deleteRows(at: (0..<moviesRows).map({ (row) in IndexPath(row: row, section: 0)}), with: .automatic)
            self.showTableView.setContentOffset(.zero, animated: true)
        }
    }
    
    func clearDataFromSeries() {
        let seriesRows = TelevisionModelController.shared.entireSeries.count
        TelevisionModelController.shared.entireSeries.removeAll()
        self.seriesIDsUsed.removeAll()
        if seriesRows == 0 {
            return
        } else {
            showTableView.deleteRows(at: (0..<seriesRows).map({ (row) in IndexPath(row: row, section: 0)}), with: .left)
            self.showTableView.setContentOffset(.zero, animated: true)
        }
    }
    
    func clearDataFromMovies() {
        let movieRows = MovieModelController.shared.movies.count
        MovieModelController.shared.movies.removeAll()
        if movieRows == 0 {
            return
        } else {
            showTableView.deleteRows(at: (0..<movieRows).map({ (row) in IndexPath(row: row, section: 0)}), with: .left)
            self.showTableView.setContentOffset(.zero, animated: true)
        }
    }

    // Tableview datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if hasSearched == false {
            return 600
        }
        
        if hasSearched == true {
            switch showSegmentedControl.selectedSegmentIndex {
            case 0: return 80
            case 1: return 125
            default: return 50
            }
        }
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hasSearched == false {
            switch showSegmentedControl.selectedSegmentIndex {
            case 0: return ArtworkModelController.shared.seriesPosters.count
            case 1: return ArtworkModelController.shared.moviePosters.count
            default: return 0
            }
        }
        
        if hasSearched == true {
            switch showSegmentedControl.selectedSegmentIndex {
            case 0: return TelevisionModelController.shared.entireSeries.count
            case 1: return MovieModelController.shared.movies.count
            default: return 0
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if hasSearched == false {
            switch showSegmentedControl.selectedSegmentIndex {
            case 0:
                guard let artworkCell = tableView.dequeueReusableCell(withIdentifier: "artworkCell", for: indexPath) as? ArtworkTableViewCell else { return UITableViewCell() }
                let artwork = ArtworkModelController.shared.seriesPosters[indexPath.row]
                artworkCell.artwork = artwork
                return artworkCell
                
            case 1:
                guard let artworkCell = tableView.dequeueReusableCell(withIdentifier: "artworkCell", for: indexPath) as? ArtworkTableViewCell else { return UITableViewCell() }
                let artwork = ArtworkModelController.shared.moviePosters[indexPath.row]
                artworkCell.artwork = artwork
                return artworkCell
                
            default: return UITableViewCell()
            }
        }
        
        if hasSearched == true {
            switch showSegmentedControl.selectedSegmentIndex {
            case 0:
                guard let seriesCell = tableView.dequeueReusableCell(withIdentifier: "seriesCell", for: indexPath) as? SeriesTableViewCell else { return UITableViewCell() }
                let series = TelevisionModelController.shared.entireSeries[indexPath.row]
                seriesCell.series = series
                seriesCell.alpha = 0
                UIView.animate(withDuration: 0.75, animations: { seriesCell.alpha = 1})
                return seriesCell
                
            case 1:
                guard let movieCell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
                
                let movie = MovieModelController.shared.movies[indexPath.row]
                movieCell.movie = movie
                movieCell.alpha = 0
                UIView.animate(withDuration: 0.75, animations: { movieCell.alpha = 1})
                return movieCell
                
            default: return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    
    // MARK: - Actions
    @IBAction func showSegmentedControlChanged(_ sender: UISegmentedControl) {
        
//        showTableView.keyboardDismissMode = .onDrag
        
        if showSegmentedControl.selectedSegmentIndex == 1 {
            
            self.clearDataFromSeries()
            self.clearDataFromSeriesArtwork()
            self.hasSearched = false
            fetchArtwork()
            navigationItem.title = "Movie Search"
            showSearchBar.placeholder = "Enter Movie Name"
            
            
        } else if showSegmentedControl.selectedSegmentIndex == 0 {
            
            self.clearDataFromMovies()
            self.clearDataFromMoviesArtwork()
            self.hasSearched = false
            fetchArtwork()
            navigationItem.title = "TV Series' Search"
            showSearchBar.placeholder = "Enter Series Name"
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromSeriesToDetailVC" {
            guard let detailVC = segue.destination as? SearchDetailViewController else { return }
            guard let indexPath = showTableView.indexPathForSelectedRow else { return }
            let selectedSeries = TelevisionModelController.shared.entireSeries[indexPath.row]
            detailVC.series = selectedSeries
        }
    }
}

//// Change color on a label
//func showTitle() {
//    (Label).transition(with: (Label, duration: 5, options: [.transitionCrossDissolve], animations: { self.(name).textcolor = UIView.blue})
//}
//
//// Spins label
//func showTitle() {
//    (label).transform = CGAffineTransform(scaleX: 0.1, y: 0.1).rotated(by: 3)
//    UIView.animate(withDuration: 4, delay: 2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.allowUserInteraction], animations: {
//        self.(label).transform = .identity
//    }) { (success) in
//        animateBackground()
//    }
//}

//Image view needs to be larger horizontally for this to work on a view controller.
//func animateBackground() {
//    UIView.animate(withDuration: 600, delay: 10, options: [.curveLinear, .autoreverse, .allowUserInteraction, .repeat], animations: {
//        let x = (self.(imageview).frame.width - self.view.frame.width)
//        self.(imageview).transform - CGAffineTransform(translationX: -x, y: 0)
//    }) { (success) in
//        self.(imageview).transform = .identity
//    }
//}


