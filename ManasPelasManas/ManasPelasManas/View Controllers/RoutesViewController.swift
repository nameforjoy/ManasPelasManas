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
    var passJourneyUUID: UUID? = nil
    let dateFormatter = DateFormatter()
    
    //let routesDataSource = RoutesVCTableDataSource()
    var newMatches: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.routesTableView.delegate = self
        self.routesTableView.dataSource = self

        self.newMatchesView.layer.cornerRadius = self.newMatchesView.frame.height / 4
        self.dateFormatter.dateFormat = "E, d MMM yyyy HH:mm"
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectJourney" {
            if let destination = segue.destination as? JourneyCompanionsViewController {
                destination.journeyId = self.passJourneyUUID
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
        
        cell.fromLabel.text = ""
        cell.toLabel.text = ""
        
        // get the season data to be displayed
        let journey: Journey = self.journeys[indexPath.row]
        
        // fill cell with extracted information
        cell.dateTitle.text = self.dateFormatter.string(from: journey.initialHour!)
        
        let pathServices = PathServices()
        
        pathServices.getAddressText(path: journey.has_path, stage: .origin, completion: { (text, error)  -> Void in
            // TODO: Tratar erro
            cell.fromLabel.text = text
        })
        pathServices.getAddressText(path: journey.has_path, stage: .destiny, completion: { (text, error)  -> Void in
            // TODO: Tratar erro
            cell.toLabel.text = text
        })
        
        switch indexPath.row {
        case 0:
            cell.photo1.image = UIImage(named: "mari")
            cell.photo2.image = UIImage(named: "ana")
            cell.photo3.image = UIImage(named: "rebeca")
        case 1:
            cell.photo1.image = UIImage(named: "sara")
            cell.photo2.image = UIImage(named: "aline")
            cell.photo3.image = UIImage(named: "brenda")
        case 2:
            cell.photo1.image = nil
            cell.photo2.image = UIImage(named: "ana")
            cell.photo3.image = UIImage(named: "elisa")
            cell.notificationView.isHidden = true
        default:
            cell.photo1.image = nil
            cell.photo2.image = UIImage(named: "lana")
            cell.photo3.image = UIImage(named: "mari")
            cell.notificationView.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.passJourneyUUID = self.journeys[indexPath.row].journeyId
        performSegue(withIdentifier: "selectJourney", sender: self)
    }
}
