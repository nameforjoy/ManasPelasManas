//
//  Journey.swift
//  ManasPelasManas
//
//  Created by Luma Gabino Vasconcelos on 22/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import Foundation

class Journey: NSObject {
    
    public var ownerId: UUID?
    public var journeyId: UUID?
    public var has_path: Path?
    public var initialHour: Date?
    public var finalHour: Date?
    public var status: String?
    public var has_confirmed_partners: Set<User>?
    public var has_requested_parteners: Set<User>?
    
    override init() {
        
    }
    
    init(ownerId: UUID?, journeyId: UUID?, has_path: Path?, initialHour: Date?, finalHour: Date?) {
        self.ownerId = ownerId
        self.journeyId = journeyId
        self.has_path = has_path
        self.initialHour = initialHour
        self.finalHour = finalHour
    }
    
}
