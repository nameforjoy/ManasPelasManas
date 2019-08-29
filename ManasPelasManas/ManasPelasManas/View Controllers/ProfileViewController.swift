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
    @objc var journeyTest: Journey?
    @objc var journeyMock: Journey?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Improviso com getFirstUser só pra entender como recuperar os dados do CoreData
        //A ideia é que tenha uma função própria que filtre os dados, como getUserByID/getUserByName/getAuthenticatedUser
//        UserServices.getFirstUser { (error, user) in
//            if (error == nil && user != nil) {
//                self.displayData(user: user!)
//            } else if user == nil {
//                self.createFakeUser()
//                self.displayData(user: user!)
//            }
//        }
        
        UserServices.getAuthenticatedUser { (error, user) in
            if (error == nil && user != nil) {
                self.displayData(user: user!)
                //print(user?.objectID)
            } else if user == nil {
                self.createFakeJourney()
                //self.createFakeUser()
                
            }
        }
            

        
    }
    
    private func displayData(user: User) {
        self.profilePhoto.image = UIImage(named: (user.photo)!)
        self.bioTitleLabel.text = (user.name)! + ", 19"
        self.bioLabel.text = (user.bio)!
    }
    
    
    func createFakeUser()
    {
        let dateString = "25/01/2000"

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "dd/MM/yyyy"

        guard let date = dateFormatter.date(from: dateString) else { return }
        
        
        //Criando objeto via CoreData
        
        self.currentUser = User()
        self.currentUser?.name = "Brenda Santos"
        self.currentUser?.bio = "I'm a wandering soul and pretty happy about it. Been back from a trip around the world one year already., connecting with people through volunteer work, getting to know the countryside and the people that live in there. Seeing the world by its best side, betting in people's kindness. Volunteering in farms, getting to know great people, using couchsurfing and making friends, learning and playing some music, having great food all over the world and some good beers and spirits. ;) Very simple to keep me happy, good food, good company, good music, (good drink when possible), a place to sleep, and a smile in my face!"
        self.currentUser?.bornDate = date
        self.currentUser?.photo = "user"
        self.currentUser?.authenticated = 1
        self.currentUser?.userId = UUID()
        
        
        UserServices.createUser(user: self.currentUser!) { error in
            if (error == nil) {
                //treat error if necessary
                
                self.currentUser?.has_journeys = [self.journeyTest!]
                self.journeyTest?.ownerId = self.currentUser?.userId
                
                UserServices.updateUser(user: self.currentUser!, { (error) in
                    if (error == nil) {
                        self.displayData(user: self.currentUser!)
                        
                        self.journeyMock = Journey()
                        self.journeyMock?.initialHour = self.createFormattedHour(hour: "31/08/2019T20:45")
                        self.journeyMock?.finalHour = self.createFormattedHour(hour: "30/08/2019T08:00")
                        self.journeyMock?.journeyId = UUID()
                        
                        
                        JourneyServices.createJourney(journey: self.journeyMock!) { error in
                            if (error == nil) {
                                
                                UserServices.getAuthenticatedUser({ (error, user) in
                                    if(error == nil && user != nil) {
                                        
                                        self.journeyMock?.ownerId = user!.userId
                                        user!.has_journeys?.insert(self.journeyMock!)
                                        
                                        UserServices.updateUser(user: user!, { (error) in
                                            if (error == nil) {
                                                print("Milagres podem acontecer")
                                            }
                                        })
                                    }
                                })
                            }
                        }
                    }
                })
            }
        }
    }
    
    func createFakeJourney() {
        self.journeyTest = Journey()
        self.journeyTest?.initialHour = createFormattedHour(hour: "30/08/2019T07:30")
        self.journeyTest?.finalHour = createFormattedHour(hour: "30/08/2019T08:00")
        self.journeyTest?.journeyId = UUID()
    

        JourneyServices.createJourney(journey: self.journeyTest!) { error in
            if (error == nil) {
                //treat error if necessary
                self.createFakeUser()
            }
        }
        

        
    }
    
 
    
    func createFormattedHour(hour: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy'T'HH:mm"
        return (formatter.date(from: hour))!
    }
}


//
//class DatabaseMemory {
//
//    static let shared = DatabaseMemory()
//
//    var journeys: [Journey] = []
//
//    private init(){
//
//    }
//
//}
