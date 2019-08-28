//
//  ProfileViewController.swift
//  ManasPelasManas
//
//  Created by Beatriz Viseu Linhares on 21/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var myProfilePicture: UIImageView!
    @IBOutlet weak var myDescription: UILabel!
    @IBOutlet weak var myBio: UILabel!
    @objc var currentUser: User?
    
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
            } else if user == nil {
                self.createFakeUser()
                self.displayData(user: self.currentUser!)
            }
        }
        
    }
    
    private func displayData(user: User) {
        self.myProfilePicture.image = UIImage(named: (user.photo)!)
        self.myDescription.text = (user.name)! + ", 19"
        self.myBio.text = (user.bio)!
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
        
        UserServices.createUser(user: self.currentUser!) { error in
            if (error != nil) {
                //treat error if necessary
            }
        }
    }
    
}
