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
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showSearchBar.text = "Suits" // For Test/Mock purposes
        DateLogic.shared.currentDate()
    }
    
    
    // MARK: - Methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchTerm = searchBar.text, searchTerm.count > 0 else { return }
        
        // Get array of Show objects to pass to the cell
        ShowModelController.shared.fetchShows(by: searchTerm) { (success) in
            
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    searchBar.text = ""
                    
                    ShowModelController.shared.repeatFetchSeasonIDs(completion: { (success) in
//                        let airDates = ShowModelController.shared.
//                        print("airDates: \(airDates)")
                        
                        if success {
                            DispatchQueue.main.async {
                                DateLogic.shared.findClosestEpisodeDate()
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            }
        }
    }
    
    // Tableview datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShowModelController.shared.shows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShowCell", for: indexPath) as? ShowTableViewCell else { return UITableViewCell() }
        let show = ShowModelController.shared.shows[indexPath.row]
        cell.show = show
//        cell.season = season
        return cell
    }
}

//// Change color on a label
//func showTitle() {
//    (Label).transition(with: (Label, duration: 5, options: [.transitionCrossDissolve], animations: { self.(title).textcolor = UIView.blue})
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


