//
//  RoutesViewController.swift
//  ManasPelasManas
//
//  Created by Beatriz Viseu Linhares on 21/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import UIKit

class RoutesViewController: UIViewController {
    
    @IBOutlet weak var routesTableView: UITableView!
    @IBOutlet weak var newMatchesView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    fileprivate var journeys: [Journey] = []
    var autheticatedUser = User()
    
    //let routesDataSource = RoutesVCTableDataSource()
    var newMatches: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.routesTableView.delegate = self
        self.routesTableView.dataSource = self

        self.newMatchesView.layer.cornerRadius = self.newMatchesView.frame.height / 4
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        JourneyServices.getAllJourneys { (error, journeys) in
            if (error == nil) {
                self.journeys = journeys!
 
                UserServices.getAuthenticatedUser({ (error, user) in
                    if(error == nil && user != nil) {
                        self.autheticatedUser = user!
                        
                        // reload table view with season information
                        DispatchQueue.main.async {
                            self.journeys = self.journeys.filter() { $0.ownerId == self.autheticatedUser.userId }
                            
                            self.routesTableView.reloadData()
                        }
                    }
                    
                    
                })
                
                
            }
            else {
                print("Error retrieving content")
            }
        }
        
    }
    
}

extension RoutesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.journeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // get a new cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "journeyCell", for: indexPath) as! FullJourneyDetailsCell
        
        // get the season data to be displayed
        if let journey:Journey = self.journeys[indexPath.row] {
            // fill cell with extracted information
            cell.dateTitle.text = journey.initialHour?.description
            cell.toLabel.text = journey.has_path.originLat?.description
            cell.fromLabel.text = journey.has_path.destinyLat?.description
        }
        return cell
    }
}
