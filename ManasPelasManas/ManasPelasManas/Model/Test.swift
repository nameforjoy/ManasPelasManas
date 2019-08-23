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
    
    func compareJourneys(journeyA: Journey, journeyB: Journey) -> Bool{
        //Comparar horários
        let matchOrigin = checkMatchingRegion(regionA: journeyA.path.origin, regionB: journeyB.path.origin)
        let matchDestiny = checkMatchingRegion(regionA: journeyA.path.destiny, regionB: journeyB.path.destiny)
        if matchOrigin && matchDestiny {
            return true
        }
        return false
    }
    
    func searchForMatch(journey: Journey, users:[User]) {
        for user in users {
            if !user.authenticated {
                for i in 0..<user.journeys.count {
                    if compareJourneys(journeyA: journey, journeyB: user.journeys[i]) {
                        print("Match!")
                        print("Journeys: \(journey.journeyId) e \(user.journeys[i].journeyId)")
                        //Retornar algoo
                    }
                }
            }
        }
    }
    
    
}
