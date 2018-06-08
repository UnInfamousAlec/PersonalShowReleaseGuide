//
//  SearchTableViewController.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 4/26/18.
//  Copyright © 2018 UnInfamous Games. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    static let shared = SearchTableViewController()

    // MARK: - Outlets
    @IBOutlet weak var showSearchBar: UISearchBar!
    @IBOutlet weak var showSegmentedControl: UISegmentedControl!
    
    
    // MARK: - Properties
    var nonFetchedEpisodes = 0
    var seriesIDsUsed = 0
//    var seasonArrayOfDictionaries = [Int : Int]()
//    var episodeArrayOfDictionaries = [Int : Int]()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DateLogicController.shared.currentDate()
        showSegmentedControl.layer.cornerRadius = 0
        showSegmentedControl.layer.borderWidth = 1
        showSearchBar.text = "suits" // For Test/Mock purposes
    }
    
    
    // MARK: - Methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        guard let searchTerm = searchBar.text, searchTerm.count > 0 else { return }
        
//        self.seasonArrayOfDictionaries.removeAll()
//        self.episodeArrayOfDictionaries.removeAll()
        self.nonFetchedEpisodes = 0
        self.seriesIDsUsed = 0

        // Get array of Show objects to pass to the cell
        TelevisionModelController.shared.fetchSeries(by: searchTerm) { (success) in

            if success {
                let seriesDictionaryKeys = TelevisionModelController.shared.seriesDictionary.keys
                for seriesID in seriesDictionaryKeys {
                    
                    TelevisionModelController.shared.fetchSeasons(withID: seriesID, completion: { (success) in
                        
                        if success {
                            let seasonNumber = DateLogicController.shared.findMostCurrentSeason(seriesID: seriesID)
                            
//                            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                            
                            if seasonNumber == -1 {
                                self.nonFetchedEpisodes += 1
                                return
                            }
                            
                            TelevisionModelController.shared.fetchEpisodes(withID: seriesID, andSeason: seasonNumber, completion: { (success) in
                                
                                if success {
                                    self.seriesIDsUsed += 1
                                    
                                    if (self.seriesIDsUsed + self.nonFetchedEpisodes) == (seriesDictionaryKeys.count) {
                                        
                                        DispatchQueue.main.async {
//                                            searchBar.text = ""
                                            self.tableView.reloadData()
                                        }
                                    }
                                }
                                
                                if !success {
                                    print("Error fetching episodes: \(Error.self)")
                                }
                            })
//                            })
                        }
                        
                        if !success {
                            print("Error fetching seasons: \(Error.self)")
                        }
                    })
                }
                
                if !success {
                    print("Error fetching shows: \(Error.self)")
                }
            }
        }
    }


    // Tableview datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TelevisionModelController.shared.seriesDictionary.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShowCell", for: indexPath) as? SeriesTableViewCell else { return UITableViewCell() }
        for key in TelevisionModelController.shared.seriesDictionary.keys {
            let series = TelevisionModelController.shared.seriesDictionary[key]
            let seasons = TelevisionModelController.shared.seasonDictionary[key]
            let episodes = TelevisionModelController.shared.episodeDictionary[key]
            cell.series = series
            cell.seasons = seasons
            cell.episodes = episodes
        }
        return cell
    }

    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        <#code#>
    //    }
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


