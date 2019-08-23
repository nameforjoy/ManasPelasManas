//
//  Journey.swift
//  ManasPelasManas
//
//  Created by Luma Gabino Vasconcelos on 22/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import Foundation

class Journey {
    var ownerId: Int
    var journeyId: Int
    var path: Path
    var date: Date
    var initialHour: Date
    var finalHour: Date
    var status: Status
    var confirmedPartners: [User]
    var requestedParteners: [User]
    
    init(journeyId: Int, userId: Int, path: Path, date: Date, initialHour: Date, finalHour: Date, status: Status) {
        self.journeyId = journeyId
        self.ownerId = userId
        self.path = path
        self.date = date
        self.initialHour = initialHour
        self.finalHour = finalHour
        self.status = status
        self.confirmedPartners = [User]()
        self.requestedParteners = [User]()
    }
    
    func partnerAcceptedJourney(journeyId: Int, userId: Int) {
        if(self.journeyId == journeyId) {
            for i in 0..<requestedParteners.count {
                if requestedParteners[i].userId == userId {
                    let user = requestedParteners[i]
                    confirmedPartners.append(user)
                    requestedParteners.remove(at: i)
                }
            }
        }
    }
    
}
