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
    public var about: String?
    public var bornDate: String?
    public var authenticated: Int?
    public var photo: String?
    public var hasJourneys: Set<Journey>?
    
    override init() {
        
    }
    
    init(userId: UUID?, name: String?, about: String?, bornDate: String?, authenticated: Int?, photo: String?) {
        self.userId = userId
        self.name = name
        self.about = about
        self.bornDate = bornDate
        self.authenticated = authenticated
        self.photo = photo
    }
    
}
