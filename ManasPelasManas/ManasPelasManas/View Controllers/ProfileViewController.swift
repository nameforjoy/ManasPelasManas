//
//  ProfileViewController.swift
//  ManasPelasManas
//
//  Created by Beatriz Viseu Linhares on 21/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import UIKit

class UserTest {
    var name: String
    var age: String
    var bio: String
    var picture: UIImage
    
    init(name: String, age: String, bio: String, pictureName: String){
        self.name = name
        self.age = age
        self.bio = bio
        self.picture = UIImage(named: pictureName)!
    }
}

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var myProfilePicture: UIImageView!
    @IBOutlet weak var myDescription: UILabel!
    @IBOutlet weak var myBio: UILabel!
    
    var user = UserTest(name: "Brenda Santos", age: "22", bio: "Sou professora, natural de Belém -PA, e atualmente moro em Campinas -SP. Sou tranquila, adoro natureza e conhecer pessoas novas, fazer amigos e conhecer lugares novos. Acho interessante a idéia do coachsurfing, além de poder ter a oportunidade de conhecer pessoas, fazer amizades. Acredito no coachsurfing!", pictureName: "user")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myProfilePicture.image = user.picture
        myDescription.text = user.name + ", " + user.age
        myBio.text = user.bio
    }
    
    
}
