

import Foundation
import MapKit
import CoreData

class MatchServices {
    
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
        guard let finalHourA = journeyA.finalHour else { return false }
        guard let initialHourB = journeyB.initialHour else { return false }
        guard let finalHourB = journeyB.finalHour else { return false }
        
        let intervalA = finalHourA.timeIntervalSince(initialHourA)
        let intervalB = finalHourB.timeIntervalSince(initialHourA)
        
        let dateIntervalA = DateInterval(start: initialHourA, duration: intervalA)
        let dateIntervalB = DateInterval(start: initialHourB, duration: intervalB)
        
        return dateIntervalA.intersects(dateIntervalB)
    
    }

    func compareJourneys(journeyA: Journey, journeyB: Journey) -> Bool {
        
        let pathServices = PathServices()
        
        let mkcOriginA = (pathServices.getCircle(path: journeyA.has_path, stage: .origin))
        let mkcOriginB = (pathServices.getCircle(path: journeyB.has_path, stage: .origin))
        let mkcDestinyA = (pathServices.getCircle(path: journeyA.has_path, stage: .destiny))
        let mkcDestinyB = (pathServices.getCircle(path: journeyB.has_path, stage: .destiny))

        let matchOrigin = checkMatchingRegion(regionA: mkcOriginA, regionB: mkcOriginB)
        let matchDestiny = checkMatchingRegion(regionA: mkcDestinyA, regionB: mkcDestinyB)
        let matchHour = checkMatchTimetable(journeyA: journeyA, journeyB: journeyB)
        if matchOrigin && matchDestiny && matchHour {
            return true
        }
        return false
    }

}
