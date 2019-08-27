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
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //createFakeUser()
        myProfilePicture.image = UIImage(named: "user")
        myDescription.text = "Brenda Oliveira, 19"
        myBio.text = "I'm a wandering soul and pretty happy about it. Been back from a trip around the world one year already., connecting with people through volunteer work, getting to know the countryside and the people that live in there. Seeing the world by its best side, betting in people's kindness. Volunteering in farms, getting to know great people, using couchsurfing and making friends, learning and playing some music, having great food all over the world and some good beers and spirits. ;) Very simple to keep me happy, good food, good company, good music, (good drink when possible), a place to sleep, and a smile in my face!"
    }
    
//    func createFakeUser()
//    {
//        let dateString = "25/01/2000"
//
//        let dateFormatter = DateFormatter()
//
//        dateFormatter.dateFormat = "dd/MM/yyyy"
//
//        guard let date = dateFormatter.date(from: dateString) else { return }
//
//        user = User(userId: 1, name: "Brenda Santos", bio:"I'm a wandering soul and pretty happy about it. Been back from a trip around the world one year already., connecting with people through volunteer work, getting to know the countryside and the people that live in there. Seeing the world by its best side, betting in people's kindness. Volunteering in farms, getting to know great people, using couchsurfing and making friends, learning and playing some music, having great food all over the world and some good beers and spirits. ;) Very simple to keep me happy, good food, good company, good music, (good drink when possible), a place to sleep, and a smile in my face!", bornDate: date, photo: "user", authenticated: true)
//    }
    
}
