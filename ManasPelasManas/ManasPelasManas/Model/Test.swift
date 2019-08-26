//
//  Test.swift
//  ManasPelasManas
//
//  Created by Luma Gabino Vasconcelos on 22/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import Foundation
import MapKit

class Test {
    func checkMatchingRegion(regionA: CLCircularRegion , regionB: CLCircularRegion) -> Bool {
        let coordA = CLLocation(latitude: regionA.center.latitude, longitude: regionA.center.longitude)
        let coordB = CLLocation(latitude: regionB.center.latitude, longitude: regionB.center.longitude)
        let distance = coordA.distance(from: coordB)
        if(regionA.radius + regionB.radius >= distance) {
            return true
        }
        return false
    }
    
    func checkMatchTimetable(journeyA: Journey, journeyB: Journey) -> Bool {
        let intervalA = journeyA.finalHour.timeIntervalSince(journeyA.initialHour)
        let intervalB = journeyB.finalHour.timeIntervalSince(journeyB.initialHour)
        let dateIntervalA = DateInterval(start: journeyA.initialHour, duration: intervalA)
        let dateIntervalB = DateInterval(start: journeyB.initialHour, duration: intervalB)
        return dateIntervalA.intersects(dateIntervalB)
    }
    
    func compareJourneys(journeyA: Journey, journeyB: Journey) -> Bool {
        let matchOrigin = checkMatchingRegion(regionA: journeyA.path.origin, regionB: journeyB.path.origin)
        let matchDestiny = checkMatchingRegion(regionA: journeyA.path.destiny, regionB: journeyB.path.destiny)
        let matchHour = checkMatchTimetable(journeyA: journeyA, journeyB: journeyB)
        if matchOrigin && matchDestiny && matchHour {
            return true
        }
        return false
    }
    
    
    
    /// Description
    ///
    /// - Parameters:
    ///   - journey: journey to be compared
    ///   - users: array of all users
    /// - Returns: return a user in case of match and nil case of no match founded
    func searchForMatch(journey: Journey, users:[User]) -> [User] {
        var userMatches = [User]()
        for user in users {
            if !user.authenticated {
                for i in 0..<user.journeys.count {
                    if compareJourneys(journeyA: journey, journeyB: user.journeys[i]) {
                        userMatches.append(user)
                    }
                }
            }
        }
        return userMatches
    }
    
    
}
