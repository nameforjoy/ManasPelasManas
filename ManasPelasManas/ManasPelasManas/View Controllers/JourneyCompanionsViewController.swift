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
    @IBOutlet weak var companionsTableView: UITableView!
    
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var arrivalLabel: UILabel!
    @IBOutlet weak var companionsLabel: UILabel!
    
    var journeyId: UUID?
    var journeyToMatch = Journey()
    var test = MatchServices()
    
    var companionID: UUID?
    var userMatches = [User]()
    
    fileprivate var journeysNotUser: [Journey] = []
    var autheticatedUser = User()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setUpInterface()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.companionsTableView.dataSource = self
        self.companionsTableView.delegate = self
        self.companionsTableView.dataSource = self
        
        JourneyServices.findById(objectID: journeyId!) { (error, journey) in
            if(error == nil && journey != nil) {
                self.journeyToMatch = journey!
                DispatchQueue.main.async {
                    self.displayJourneyDescription(completion: { error in
                        if error == nil {
                            self.setupAccessibility()
                        }
                    })
                }
            }
        }
        
        JourneyServices.getAllJourneys { (error, journeys) in
            if (error == nil) {
                self.journeysNotUser = journeys!
                
                UserServices.getAuthenticatedUser({ (error, user) in
                    if(error == nil && user != nil) {
                        self.autheticatedUser = user!
                        // reload table view with season information
                        DispatchQueue.main.async {
                            self.journeysNotUser = self.journeysNotUser.filter { $0.ownerId! != self.autheticatedUser.userId }
                            self.searchForMatch()
                        }
                    }
                })
            } else {
                print("Error retrieving content")
            }
        }
    }
    
    // MARK: - Accessibility setup
     private func setupAccessibility() {
        //1. Data e horário
        self.dateLabel.isAccessibilityElement = true
        self.timeRangeLabel.isAccessibilityElement = false
        //accessibility label setado na célula
        
        //2. Saída e chegada
        self.departureLabel.isAccessibilityElement = true
        self.fromLabel.isAccessibilityElement = false
        self.arrivalLabel.isAccessibilityElement = false
        self.toLabel.isAccessibilityElement = false
        self.departureLabel.accessibilityLabel = "\(self.departureLabel.text!) de \(self.fromLabel.text!) e \(self.arrivalLabel.text!) em \(self.toLabel.text!)"

        //4. Companheiras
        self.companionsLabel.isAccessibilityElement = true
        self.companionsLabel.accessibilityLabel = "Suas companheiras são"
     }
    
    // MARK: - VC methods
    private func setUpInterface() {
        
        self.departureLabel.text = NSLocalizedString("Departure MyJourney", comment: "Departure address title lable on the screen for a selected journey")
        self.arrivalLabel.text = NSLocalizedString("Arrival MyJourney", comment: "Arrival address title lable on the screen for a selected journey")
        self.companionsLabel.text = NSLocalizedString("Companions MyJourney", comment: "Title for tableView with all companions found for a selected journey")
        
        self.navigationItem.title = NSLocalizedString("Journey details", comment: "Navigation title of screen in which the journey details (meeting point, destination, and time range) are displayed, as well as possible companions for that journey")
    }
    
    func journeyMatchedAndIsValid(journeyA: Journey, journeyB: Journey) -> Bool {
        do {
            return try test.compareJourneys(journeyA: journeyA, journeyB: journeyB)
        } catch {
            return false
        }
    }
    
    func searchForMatch() {
        for journey in journeysNotUser {
            
            let journeysMatched = journeyMatchedAndIsValid(journeyA: self.journeyToMatch, journeyB: journey)
            
            if journeysMatched && journey.ownerId != nil {
                UserServices.findById(objectID: journey.ownerId!) { (error, user) in
                    if(error == nil && user != nil) {
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
        if segue.identifier == "showCompanionProfile",
            let destination = segue.destination as? CompanionProfileViewController {
            destination.companionID = self.companionID
        }
    }
        
    func displayJourneyDescription(completion: @escaping (Error?) -> Void) {
        
        let pathServices = PathServices()
        
        self.dateLabel.text = DateHelper.dateToString(date: self.journeyToMatch.initialHour!, format: "E, d MMM yyyy")
        
        let initialHour = DateHelper.dateToString(date: self.journeyToMatch.initialHour!, format: "HH:mm")
        let finalHour = DateHelper.dateToString(date: self.journeyToMatch.finalHour!, format: "HH:mm")
        
        self.timeRangeLabel.text = initialHour + " - "  + finalHour
        
        //Accessibility label
        self.dateLabel.accessibilityLabel = DateHelper.dateToStringAccessible(initialHour: self.journeyToMatch.initialHour!, finalHour: self.journeyToMatch.finalHour!)
        guard let pathJourney = self.journeyToMatch.hasPath else { return }
        
        //Passando o completion dogetAddress de volta para a chamada dessa msm função atual
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        dispatchGroup.enter()
        
        pathServices.getAddressText(path: pathJourney, stage: .origin, completion: { (text, error) -> Void in
            // TODO: Tratar erro
            self.fromLabel.text = text
            dispatchGroup.leave()
            print(error ?? "Error getting origin address from reverse geocode")
        })
        pathServices.getAddressText(path: pathJourney, stage: .destiny, completion: { (text, error) -> Void in
            // TODO: Tratar erro
            self.toLabel.text = text
            dispatchGroup.leave()
            print(error ?? "Error getting destiny address from reverse geocode")
        })
        
        dispatchGroup.notify(queue: .main) {
           completion(nil)
        }

    }
}

extension JourneyCompanionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userMatches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // get a new cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "companionCell", for: indexPath) as? CompanionCell else {
            print("Cell not CompanionCell type")
        return UITableViewCell()}
        
        // get the season data to be displayed
        let user: User = self.userMatches[indexPath.row]
        self.companionID = user.userId
        
        // fill cell with extracted information
        cell.userPhoto.image = UIImage(named: user.photo!)
        cell.nameLabel.text = user.name?.description
        cell.descriptionLabel.text = user.about
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showCompanionProfile", sender: self)
    }
}
