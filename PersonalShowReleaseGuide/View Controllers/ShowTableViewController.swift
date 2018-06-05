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
        
        showSearchBar.text = "Thrones" // For Test/Mock purposes
        DateLogic.shared.currentDate()
        showSegmentedControl.layer.cornerRadius = 0
        showSegmentedControl.layer.borderWidth = 1
    }
    
    
    
    // Tableview datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TelevisionModelController.shared.series.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShowCell", for: indexPath) as? ShowTableViewCell else { return UITableViewCell() }
        let series = TelevisionModelController.shared.series[indexPath.row]
        let currentSeason = TelevisionModelController.shared.currentSeason[indexPath.row]
        cell.series = series
        cell.currentSeason = currentSeason
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    
    // MARK: - Methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchTerm = searchBar.text, searchTerm.count > 0 else { return }
        
        // Get array of Show objects to pass to the cell
        TelevisionModelController.shared.fetchSeries(by: searchTerm) { (success) in
            
            if success {
                for _ in TelevisionModelController.shared.series {
                    
                    TelevisionModelController.shared.fetchSeasons(completion: { (success) in
                        
                        if success {
                            DispatchQueue.main.async {
                                searchBar.text = ""
                                self.tableView.reloadData()
                            }
                        }
                        
                        if !success {
                            print("Error fetching seasons")
                        }
                    })
                }
            }
            
            if !success {
                print("Error fetching shows")
            }
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


