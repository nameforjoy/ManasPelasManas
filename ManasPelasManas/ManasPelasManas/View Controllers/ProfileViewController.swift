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
    @objc var currentUser: User?
    @objc var authenticatedUser: User?
    @objc var journeyTest: Journey?
    @objc var pathTest: Path?
    @objc var journeyMock: Journey?
    @objc var pathMock: Path?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserServices.getAuthenticatedUser { (error, user) in
            if (error == nil && user != nil) {
                self.displayData(user: user!)
                //print(user?.objectID)
            } else if user == nil {
                self.createFakeJourney()
                self.createAuthenticatedUser()
                
            }
        }
    }
    
    private func displayData(user: User) {
        self.profilePhoto.image = UIImage(named: (user.photo)!)
        self.bioTitleLabel.text = (user.name)! + ", 19"
        self.bioLabel.text = (user.bio)!
    }
    
    
    func createCurrentUser()
    {
        //Criando objeto via CoreData
        
        self.currentUser = User()
        self.currentUser?.name = "Julia Silva"
        self.currentUser?.bio = "Descricao aqui"
        self.currentUser?.bornDate = Date()
        self.currentUser?.photo = "annalise.photo"
        self.currentUser?.authenticated = 0
        self.currentUser?.userId = UUID()
        
        //PARA AQUI!!!
        UserServices.createUser(user: self.currentUser!) { error in
            if (error == nil) {
                //treat error if necessary
                
                self.currentUser?.has_journeys = [self.journeyTest!]
                self.journeyTest?.ownerId = self.currentUser?.userId

                UserServices.updateUser(user: self.currentUser!, { (error) in
                    if (error == nil) {

                    }
                })
            }
        }
        
    }
    
    func createAuthenticatedUser() {
        let dateString = "25/01/2000"
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        guard let date = dateFormatter.date(from: dateString) else { return }
        
        self.authenticatedUser = User()
        self.authenticatedUser?.name = "Brenda Santos"
        self.authenticatedUser?.bio = "I'm a wandering soul and pretty happy about it. Been back from a trip around the world one year already., connecting with people through volunteer work, getting to know the countryside and the people that live in there. Seeing the world by its best side, betting in people's kindness. Volunteering in farms, getting to know great people, using couchsurfing and making friends, learning and playing some music, having great food all over the world and some good beers and spirits. ;) Very simple to keep me happy, good food, good company, good music, (good drink when possible), a place to sleep, and a smile in my face!"
        self.authenticatedUser?.bornDate = date
        self.authenticatedUser?.photo = "user"
        self.authenticatedUser?.authenticated = 1
        self.authenticatedUser?.userId = UUID()
        
        UserServices.createUser(user: self.authenticatedUser!) { (error) in
            if (error == nil) {
                self.displayData(user: self.authenticatedUser!)
            }
        }
    }
    
    
    func createFakeJourney() {
        self.journeyTest = Journey()
        self.journeyTest?.initialHour = createFormattedHour(hour: "02/09/2019T09:30")
        self.journeyTest?.finalHour = createFormattedHour(hour: "02/09/2019T23:00")
        self.journeyTest?.journeyId = UUID()

        createCBToMorasPath()
        
        //treat error if necessary
        if(self.pathTest != nil) {

            //criar metodo no services para salvar path antes de criar journey
            self.pathTest?.managedObjectContext?.insert(self.journeyTest!)
            do {
                try self.pathTest?.managedObjectContext?.save()
            } catch {
                print("Ooops \(error)")
            }
            self.journeyTest!.has_path = self.pathTest!
            JourneyServices.createJourney(journey: self.journeyTest!, { (error) in
                if (error == nil) {
                    self.createCurrentUser()
                }
            })
        }
    }
    
    func createFormattedHour(hour: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy'T'HH:mm"
        return (formatter.date(from: hour))!
    }
    
    
    
    func createCBToMorasPath() {
        pathTest = Path()
        self.pathTest?.pathId = UUID()
        self.pathTest?.originLat = -22.817889
        self.pathTest?.originLong = -47.068661
        self.pathTest?.originRadius = 400
        self.pathTest?.destinyLat = -22.821561
        self.pathTest?.destinyLong = -47.088216
        self.pathTest?.destinyRadius = 200
        
        PathServices.createPath(path: self.pathTest!) { error in
            if (error != nil) {
                //treat error
            }
        }
    }
}

