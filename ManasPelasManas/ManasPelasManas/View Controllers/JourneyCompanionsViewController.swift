//
//  JourneyCompanionsViewController.swift
//  ManasPelasManas
//
//  Created by Joyce Simão Clímaco on 28/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import Foundation
import UIKit

class JourneyCompanionsViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeRangeLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var companionsTableView: UITableView!
    
    var journeyId: UUID?
    var journeyToMatch = Journey()
    var test = Test()
    
    var companionID: UUID? = nil
    var userMatches = [User]()
    
    fileprivate var journeysNotUser: [Journey] = []
    var autheticatedUser = User()
    
    let dateFormatter = DateFormatter()
    let hourFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.companionsTableView.dataSource = self
        self.companionsTableView.delegate = self
        self.companionsTableView.dataSource = self
        
        JourneyServices.findById(objectID: journeyId!) { (error, journey) in
            if(error == nil && journey != nil) {
                self.journeyToMatch = journey!
            }
        }
        
        if let date = self.journeyToMatch.date {
            self.dateFormatter.dateFormat = "E, d MMM yyyy"
            self.dateLabel.text = self.dateFormatter.string(from: date)
            
            self.hourFormatter.dateFormat = "HH:mm"
            let initialHour: String = self.hourFormatter.string(from: self.journeyToMatch.initialHour!)
            let finalHour: String = self.hourFormatter.string(from: self.journeyToMatch.finalHour!)
            self.timeRangeLabel.text = initialHour + " - "  + finalHour
        }
        
        JourneyServices.getAllJourneys { (error, journeys) in
            if (error == nil) {
                self.journeysNotUser = journeys!
                
                UserServices.getAuthenticatedUser({ (error, user) in
                    if(error == nil && user != nil) {
                        self.autheticatedUser = user!
                        // reload table view with season information
                        DispatchQueue.main.async {
                            self.journeysNotUser = self.journeysNotUser.filter() { $0.ownerId != self.autheticatedUser.userId }
                            self.companionsTableView.reloadData()
                            self.searchForMatch()
                        }
                    }
                })
            }
            else {
                print("Error retrieving content")
            }
        }
    }
    
    func searchForMatch() {
        for journey in journeysNotUser {
            if test.compareJourneys(journeyA: journey, journeyB: self.journeyToMatch) && journey.ownerId != nil{
                UserServices.findById(objectID: journey.ownerId!) { (error, user) in
                    if(error == nil && user != nil)  {
                        self.userMatches.append(user!)
                        OperationQueue.main.addOperation {
                            self.companionsTableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCompanionProfile" {
            let destination = segue.destination as! CompanionProfileViewController
            destination.companionID = self.companionID
        }
    }
    
}

extension JourneyCompanionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userMatches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // get a new cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "companionCell", for: indexPath) as! CompanionCell
        
        // get the season data to be displayed
        let user: User = self.userMatches[indexPath.row]
        self.companionID = user.userId
        
        // fill cell with extracted information
        cell.userPhoto.image = UIImage(named: user.photo!)
        cell.nameLabel.text = user.name?.description
        cell.descriptionLabel.text = user.bio
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showCompanionProfile", sender: self)
    }
}
