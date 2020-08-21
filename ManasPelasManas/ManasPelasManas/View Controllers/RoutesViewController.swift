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
    
    fileprivate var journeys: [Journey] = []
    var autheticatedUser = User()
    let dateFormatter = DateFormatter()
    var passJourneyUUID: UUID?
    
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
        
        self.setUpInterface()
        
        self.retrieveAllJourneysFromUser()
    }
    
    func getAuthUserFromDB(_ completion: @escaping (_ authUser: User) -> Void) {
        UserServices.getAuthenticatedUser { (error, user) in
            if error == nil, let authUser: User = user {
                completion(authUser)
            } else {
                print("Error retrieving Auth User")
            }
        }
    }
    
    func retrieveAllJourneysFromUser() {
        getAuthUserFromDB { (authUser) in
            JourneyServices.getAllJourneysFromUser(user: authUser) { (error, journeys) in
                if error == nil, let authUserJourneys: [Journey] = journeys {
                    DispatchQueue.main.async {
                        self.journeys = authUserJourneys
                        self.routesTableView.reloadData()
                    }
                } else {
                    print("Error retrieving content")
                }
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
        return self.journeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "journeyCell", for: indexPath) as! FullJourneyDetailsCell
        
        cell.fromLabel.text = ""
        cell.toLabel.text = ""

        // get the season data to be displayed
        let journey: Journey = self.journeys[indexPath.row]

        // checks if address text has been loaded already
        
        if let originAddress: String = journey.has_path?.originAddress,
            let destinyAddress: String = journey.has_path?.destinyAddress {
            cell.fromLabel.text = originAddress
            cell.toLabel.text = destinyAddress
        } else {
            //Get missing information
            loadJourneyAdditionalInfo(journey: journey, index: indexPath.row)
        }
        
        // fill cell with extracted information
        cell.dateTitle.text = self.dateFormatter.string(from: journey.initialHour!)
        
        // Accesibility date
        // Tentar enteder isso!!!
        // cell.dateTitle.isAccessibilityElement = true
        cell.dateTitle.accessibilityLabel = dateAccessible(initialHour: journey.initialHour!, finalHour: journey.finalHour!)
        
        return cell
    }

    private func loadJourneyAdditionalInfo(journey: Journey, index: Int) {
        let group = DispatchGroup()
        let pathServices = PathServices()
        let filledJourney = journey
        group.enter()
        group.enter()

        pathServices.getAddressText(path: journey.has_path!,
                                    stage: .origin) { (origin, resultError) in
                                        if let originError = resultError {
                                            print("Origin error: \(originError)")
                                        } else {
                                            filledJourney.has_path?.originAddress = origin
                                        }
                                        group.leave()
        }

        pathServices.getAddressText(path: journey.has_path!,
                                           stage: .destiny) { (destiny, resultError) in
                                               if let destinyError = resultError {
                                                print("Destiny error: \(destinyError)")
                                               } else {
                                                filledJourney.has_path?.destinyAddress = destiny
                                               }
                                               group.leave()
        }

        group.notify(queue: .main) {
            //filledJourney.isAllInfoLoaded = true
            self.journeys[index] = filledJourney
            self.routesTableView.reloadRows(at: [IndexPath(row: index, section: 0)],
                                       with: .automatic)
        }

    }
    
    func dateAccessible(initialHour: Date, finalHour: Date) -> String {
        let calendar = Calendar.current
        let iniHour = calendar.component(.hour, from: initialHour)
        let iniMinute = calendar.component(.minute, from: initialHour)
        let finHour = calendar.component(.hour, from: finalHour)
        let finMinute = calendar.component(.minute, from: finalHour)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "pt_BR")
        let dayString = dateFormatter.string(from: initialHour)
        
        return "\(dayString), entre \(iniHour) horas e \(iniMinute) minutos e as \(finHour) e \(finMinute) minutos"
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.passJourneyUUID = self.journeys[indexPath.row].journeyId
        performSegue(withIdentifier: "selectJourney", sender: self)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
