//
//  RoutesViewController.swift
//  ManasPelasManas
//
//  Created by Beatriz Viseu Linhares on 21/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import UIKit

struct JourneyRepresentation {
    var journey: Journey
    var origin: String?
    var destiny: String?
    var isAllInfoLoaded: Bool = false
}

class RoutesViewController: UIViewController {
    
    @IBOutlet weak var routesTableView: UITableView!
    
    fileprivate var journeyRepresentations: [JourneyRepresentation] = []
    var autheticatedUser = User()
    var passJourneyUUID: UUID? = nil
    let dateFormatter = DateFormatter()
    
    var newMatches: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.routesTableView.delegate = self
        self.routesTableView.dataSource = self
        self.routesTableView.estimatedRowHeight = 165
        self.routesTableView.rowHeight = UITableView.automaticDimension
        self.dateFormatter.dateFormat = "E, d MMM yyyy HH:mm"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Guarantees Large Title preference when the view controller has a Table View
        self.routesTableView.contentInsetAdjustmentBehavior = .never
        
        setUpInterface()
        
        JourneyServices.getAllJourneys { (error, journeys) in
            if (error == nil) {
                self.journeyRepresentations = journeys!.map { (journey) -> JourneyRepresentation in
                    JourneyRepresentation(journey: journey)
                }
                //self.journeys = journeys!
 
                UserServices.getAuthenticatedUser({ (error, user) in
                    if(error == nil && user != nil) {
                        self.autheticatedUser = user!
                        
                        // reload table view with season information
                        DispatchQueue.main.async {
                            self.journeyRepresentations = self.journeyRepresentations.filter() { $0.journey.ownerId == self.autheticatedUser.userId }
                            
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
    
    private func setUpInterface() {
        self.navigationItem.title = NSLocalizedString("List of journeys title", comment: "Navigation title of the screen which constains the table with all of the user's journeys.")
    }
    
}

extension RoutesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.journeyRepresentations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // get a new cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "journeyCell", for: indexPath) as! FullJourneyDetailsCell

        cell.fromLabel.text = ""
        cell.toLabel.text = ""

        // get the season data to be displayed
        let journeyRepresentation: JourneyRepresentation = self.journeyRepresentations[indexPath.row]

        // checks if address text has been loaded already
        if (journeyRepresentation.isAllInfoLoaded) {
            //Fill information
            cell.fromLabel.text = journeyRepresentation.origin
            cell.toLabel.text = journeyRepresentation.destiny
        } else {
            //Get missing information
            loadJourneyAdditionalInfo(journey: journeyRepresentation, index: indexPath.row)
        }
        
        // fill cell with extracted information
        cell.dateTitle.text = self.dateFormatter.string(from: journeyRepresentation.journey.initialHour!)
        
        return cell
    }

    private func loadJourneyAdditionalInfo(journey: JourneyRepresentation, index: Int) {
        let group = DispatchGroup()
        let pathServices = PathServices()
        var filledJourney = journey
        var error: Error? = nil
        group.enter()
        group.enter()

        pathServices.getAddressText(path: journey.journey.has_path!,
                                    stage: .origin) { (origin, resultError) in
                                        if let originError = resultError {
                                            error = originError
                                        } else {
                                            filledJourney.origin = origin
                                        }
                                        group.leave()
        }

        pathServices.getAddressText(path: journey.journey.has_path!,
                                           stage: .destiny) { (destiny, resultError) in
                                               if let destinyError = resultError {
                                                   error = destinyError
                                               } else {
                                                   filledJourney.destiny = destiny
                                               }
                                               group.leave()
               }


        group.notify(queue: .main) {
            filledJourney.isAllInfoLoaded = true
            self.journeyRepresentations[index] = filledJourney
            self.routesTableView.reloadRows(at: [IndexPath(row: index, section: 0)],
                                       with: .automatic)
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.passJourneyUUID = self.journeyRepresentations[indexPath.row].journey.journeyId
        performSegue(withIdentifier: "selectJourney", sender: self)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
