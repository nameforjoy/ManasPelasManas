//
//  User.swift
//  ManasPelasManas
//
//  Created by Luma Gabino Vasconcelos on 22/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import Foundation

class User: NSObject {
    
    public var userId: UUID?
    public var name: String?
    public var bio: String?
    public var bornDate: String?
    public var authenticated: Int?
    public var photo: String?
    public var has_journeys: Set<Journey>?
    
    override init() {
        
    }
    
    init(userId: UUID?, name: String?, bio: String?, bornDate: String?, authenticated: Int?, photo: String?) {
        self.userId = userId
        self.name = name
        self.bio = bio
        self.bornDate = bornDate
        self.authenticated = authenticated
        self.photo = photo
    }
    
}

