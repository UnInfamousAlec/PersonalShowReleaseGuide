//
//  ShowTableViewController.swift
//  PersonalShowReleaseGuide
//
//  Created by Alec Osborne on 4/26/18.
//  Copyright © 2018 UnInfamous Games. All rights reserved.
//

import UIKit

class ShowTableViewController: UITableViewController, UISearchBarDelegate {

    // MARK: - Outlets
    @IBOutlet weak var showSearchBar: UISearchBar!
    @IBOutlet weak var showSegmentedControl: UISegmentedControl!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DateLogic.shared.currentDate()
        showSegmentedControl.layer.cornerRadius = 0
        showSegmentedControl.layer.borderWidth = 1
        showSearchBar.text = "Thrones" // For Test/Mock purposes
    }
    
    
    // MARK: - Methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        guard let searchTerm = searchBar.text, searchTerm.count > 0 else { return }

        // Get array of Show objects to pass to the cell
        TelevisionModelController.shared.fetchSeries(by: searchTerm) { (success) in

            if success {
                
                let seriesResultsCount = (TelevisionModelController.shared.series.count - 1)
                for number in 0...seriesResultsCount {
                    
                    let seriesID = TelevisionModelController.shared.seriesIDs[number]
                    
                    TelevisionModelController.shared.fetchSeasons(withID: seriesID, completion: { (success) in
                        
                        if success {
                            
                            let tvSeriesIDs = TelevisionModelController.shared.seriesIDs
                            let seriesID = TelevisionModelController.shared.seriesIDs[number]
                            
                            let tvSeasonNumbers = TelevisionModelController.shared.currentSeason
                            let seasonNumber = TelevisionModelController.shared.currentSeason[number]
                            
                            TelevisionModelController.shared.fetchEpisodes(withID: seriesID, andSeason: seasonNumber, completion: { (success) in
                                
                                if success {
                                    DispatchQueue.main.async {
                                        //                                            searchBar.text = ""
                                        self.tableView.reloadData()
                                    }
                                }
                                
                                if !success {
                                    print("Error fetching episodes")
                                }
                            })
                        }

                        if !success {
                            print("Error fetching seasons")
                        }
                    })
                }

                if !success {
                    print("Error fetching shows")
                }
            }
        }
    }


    // Tableview datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TelevisionModelController.shared.series.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShowCell", for: indexPath) as? ShowTableViewCell else { return UITableViewCell() }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            let series = TelevisionModelController.shared.series[indexPath.row]
            let cs = TelevisionModelController.shared.currentSeason
            let currentSeason = TelevisionModelController.shared.currentSeason[indexPath.row]
            let ce = TelevisionModelController.shared.currentEpisode
                    let currentEpisode = TelevisionModelController.shared.currentEpisode[indexPath.row]
            cell.series = series
            cell.currentSeason = currentSeason
            cell.currentEpisode = currentEpisode
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


