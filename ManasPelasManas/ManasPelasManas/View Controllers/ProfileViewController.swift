//
//  ProfileViewController.swift
//  ManasPelasManas
//
//  Created by Beatriz Viseu Linhares on 21/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var bioTitleLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    var currentUser: User?
    var authenticatedUser: User?
    @objc var journeyTest: Journey?
    @objc var pathTest: Path?
    @objc var journeyMock: Journey?
    @objc var pathMock: Path?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserServices.getAuthenticatedUser { (error, user) in
            if (error == nil && user != nil) {
                self.displayData(user: user!)
            } else if user == nil {
                //tratar errro
                //self.createFakeJourney()
            }
        }
    }
    
    private func displayData(user: User) {
        self.profilePhoto.image = UIImage(named: (user.photo)!)
        self.bioTitleLabel.text = (user.name)! + ", 19"
        self.bioLabel.text = (user.bio)!
    }
    
    
    
    
//    func createFakeJourney() {
//        self.journeyTest = Journey()
//        self.journeyTest?.initialHour = createFormattedHour(hour: "01/09/2019T09:30")
//        self.journeyTest?.finalHour = createFormattedHour(hour: "05/09/2019T23:00")
//        self.journeyTest?.journeyId = UUID()
//
//        createCBToMorasPath()
//
//        //treat error if necessary
//        if(self.pathTest != nil) {
//
//            //criar metodo no services para salvar path antes de criar journey
//            self.pathTest?.managedObjectContext?.insert(self.journeyTest!)
//            do {
//                try self.pathTest?.managedObjectContext?.save()
//            } catch {
//                print("Ooops \(error)")
//            }
//            self.journeyTest!.has_path = self.pathTest!
//            JourneyServices.createJourney(journey: self.journeyTest!, { (error) in
//                if (error == nil) {
//                    self.createCurrentUser()
//                }
//            })
//        }
//    }
//
//    func createFormattedHour(hour: String) -> Date {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd/MM/yyyy'T'HH:mm"
//        return (formatter.date(from: hour))!
//    }
//
//    func createCBToMorasPath() {
//        pathTest = Path()
//        self.pathTest?.pathId = UUID()
//        self.pathTest?.originLat = -22.817889
//        self.pathTest?.originLong = -47.068661
//        self.pathTest?.originRadius = 400
//        self.pathTest?.destinyLat = -22.821561
//        self.pathTest?.destinyLong = -47.088216
//        self.pathTest?.destinyRadius = 200
//
//        PathServices.createPath(path: self.pathTest!) { error in
//            if (error != nil) {
//                //treat error
//            }
//        }
//    }
    
    
}

