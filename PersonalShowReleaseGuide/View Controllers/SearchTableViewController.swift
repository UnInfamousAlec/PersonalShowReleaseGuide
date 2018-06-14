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
    var seriesIDsUsed = [Int]()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DateLogicController.shared.currentDate()
        showSegmentedControl.layer.cornerRadius = 0
        showSegmentedControl.layer.borderWidth = 1
        showSearchBar.text = "if" // For Mock purposes
    }
    
    
    // MARK: - Methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchTerm = searchBar.text, searchTerm.count > 0 else { return }
        
        self.seriesIDsUsed.removeAll()

        // Get array of Series IDs to fetch Series/Seasons with
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
                            
                            TelevisionModelController.shared.fetchEpisodes(withSeasonID: seriesID, andSeason: seasonNumber, completion: { (success) in
                                
                                if success {
                                    self.seriesIDsUsed.append(seriesID)
                                    
                                    if self.seriesIDsUsed.count == TelevisionModelController.shared.entireSeries.count {
                                        
                                        DispatchQueue.main.async {
//                                            searchBar.text = ""
                                            TelevisionModelController.shared.entireSeries.sort(by: {$0.popularity > $1.popularity} )
                                            TelevisionModelController.shared.entireSeries.forEach{ print($0.name, $0.popularity) }
                                            self.tableView.reloadData()
                                        }
                                    }
                                }
                                
                                if !success {
                                    print("Error fetching episodes: \(Error.self)")
                                }
                            })
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
        return TelevisionModelController.shared.entireSeries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShowCell", for: indexPath) as? SeriesTableViewCell else { return UITableViewCell() }
        let series = TelevisionModelController.shared.entireSeries[indexPath.row]
        cell.series = series
        return cell
    }
    
//    func sortSeriesDictionary(series: Series) -> [Series] {
//        let sortedSeries = [Series]
//        for show in series {
//            
//        }
//    }
//        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        }
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


