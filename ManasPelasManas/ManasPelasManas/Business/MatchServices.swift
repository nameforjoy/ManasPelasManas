

import Foundation
import MapKit
import CoreData

class MatchServices {
    
    func checkMatchingRegion(regionA: MKCircle, regionB: MKCircle) throws -> Bool {
        
        let maxRadius: Double = 11*1000
        let minRadius: Double = 0.5*1000
        
        if regionA.radius < minRadius || regionA.radius > maxRadius || regionB.radius < minRadius || regionB.radius > maxRadius {
            throw Errors.RegionRadiusOutsideTheAllowedRange
        }
        if abs(regionA.coordinate.latitude) > 90 || abs(regionB.coordinate.latitude) > 90 {
            throw Errors.LatitudeOutsideRange
        }
        
        let coordA = CLLocation(latitude: regionA.coordinate.latitude, longitude: regionA.coordinate.longitude)
        let coordB = CLLocation(latitude: regionB.coordinate.latitude, longitude: regionB.coordinate.longitude)
        let distance = coordA.distance(from: coordB)
        
        if (regionA.radius + regionB.radius >= distance) {
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

    func compareJourneys(journeyA: Journey, journeyB: Journey) throws -> Bool {
        
        let pathServices = PathServices()
        
        let mkcOriginA = (pathServices.getCircle(path: journeyA.has_path, stage: .origin))
        let mkcOriginB = (pathServices.getCircle(path: journeyB.has_path, stage: .origin))
        let mkcDestinyA = (pathServices.getCircle(path: journeyA.has_path, stage: .destiny))
        let mkcDestinyB = (pathServices.getCircle(path: journeyB.has_path, stage: .destiny))
        
        do {
            let matchOrigin = try checkMatchingRegion(regionA: mkcOriginA, regionB: mkcOriginB)
            let matchDestiny = try checkMatchingRegion(regionA: mkcDestinyA, regionB: mkcDestinyB)
            let matchHour = checkMatchTimetable(journeyA: journeyA, journeyB: journeyB)
            
            if matchOrigin && matchDestiny && matchHour {
                return true
            }
        } catch {
            throw error
        }
        
        return false
    }

}
