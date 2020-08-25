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
    public var hasPath: Path?
    public var initialHour: Date?
    public var finalHour: Date?
    public var status: String?
    public var hasConfirmedPartners: Set<User>?
    public var hasRequestedParteners: Set<User>?
    
    override init() {
        
    }
    
    init(ownerId: UUID?, journeyId: UUID?, hasPath: Path?, initialHour: Date?, finalHour: Date?) {
        self.ownerId = ownerId
        self.journeyId = journeyId
        self.hasPath = hasPath
        self.initialHour = initialHour
        self.finalHour = finalHour
    }
    
}
