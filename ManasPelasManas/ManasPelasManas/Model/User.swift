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
    var bornDate: Date
    var autenticated: Bool
    var photo: String
    var journeys: [Journey]
    
    init (userId: Int, name: String, bornDate: Date, photo: String, autenticated: Bool) {
        self.name = name
        self.bornDate = bornDate
        self.photo = photo
        self.autenticated = autenticated
        self.userId = userId
        self.journeys = [Journey]()
    }
    
}
