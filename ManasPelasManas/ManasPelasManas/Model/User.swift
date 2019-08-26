//
//  User.swift
//  ManasPelasManas
//
//  Created by Luma Gabino Vasconcelos on 22/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import Foundation

class User {
    var userId: Int
    var name: String
    var bio: String
    var bornDate: Date
    var authenticated: Bool
    var photo: String
    var journeys: [Journey]
    
    init (userId: Int, name: String, bio: String, bornDate: Date, photo: String, authenticated: Bool) {
        self.name = name
        self.bio = bio
        self.bornDate = bornDate
        self.photo = photo
        self.authenticated = authenticated
        self.userId = userId
        self.journeys = [Journey]()
    }
    
}
