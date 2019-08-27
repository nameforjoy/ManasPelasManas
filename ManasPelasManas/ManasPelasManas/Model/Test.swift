//
//  Test.swift
//  ManasPelasManas
//
//  Created by Luma Gabino Vasconcelos on 22/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import Foundation
import MapKit
import CoreData

class Test {
    func checkMatchingRegion(regionA: MKCircle , regionB: MKCircle) -> Bool {
        let coordA = CLLocation(latitude: regionA.coordinate.latitude, longitude: regionA.coordinate.longitude)
        let coordB = CLLocation(latitude: regionB.coordinate.latitude, longitude: regionB.coordinate.longitude)
        let distance = coordA.distance(from: coordB)
        if(regionA.radius + regionB.radius >= distance) {
            return true
        }
        return false
    }

    func checkMatchTimetable(journeyA: Journey, journeyB: Journey) -> Bool {
        guard let initialHourA = journeyA.initialHour else { return false }
        guard let finalHourA = journeyA.initialHour else { return false }
        guard let initialHourB = journeyB.initialHour else { return false }
        guard let finalHourB = journeyA.initialHour else { return false }
        
        let intervalA = finalHourA.timeIntervalSince(initialHourA)
        let intervalB = finalHourB.timeIntervalSince(initialHourA)
        let dateIntervalA = DateInterval(start: initialHourA, duration: intervalA)
        let dateIntervalB = DateInterval(start: initialHourB, duration: intervalB)
        return dateIntervalA.intersects(dateIntervalB)
    }

    
    
    func compareJourneys(journeyA: Journey, journeyB: Journey) -> Bool {
        let mkcOriginA = (journeyA.has_path?.getOriginCircle())!
        let mkcOriginB = (journeyB.has_path?.getOriginCircle())!
        //Get destiny
        //let mkcDestinyA = journeyA.has_path?.
        //let mkcDestinyA = journeyA.has_path?.
        
        let matchOrigin = checkMatchingRegion(regionA: mkcOriginA, regionB: mkcOriginB)
        //let matchDestiny = checkMatchingRegion(regionA: journeyA.has_path.destiny!, regionB: journeyB.has_path.destiny!)
        let matchHour = checkMatchTimetable(journeyA: journeyA, journeyB: journeyB)
        if matchOrigin /*&& matchDestiny*/ && matchHour {
            return true
        }
        return false
    }
    
    
//ESPERAR PARA QUANDO FOR PRECISO!!!!!!
    /// Description
    ///
    /// - Parameters:
    ///   - journey: journey to be compared
    ///   - users: array of all users
    /// - Returns: return a user in case of match and nil case of no match founded
//    func searchForMatch(journey: Journey, users:[User]) -> [User] {
//        var userMatches = [User]()
//        for user in users {
//            if !user.authenticated {
//                for i in 0..< {
//                    if compareJourneys(journeyA: journey, journeyB: user.journeys[i]) {
//                        userMatches.append(user)
//                    }
//                }
//            }
//        }
//        return userMatches
//    }


}
