//
//  Path.swift
//  ManasPelasManas
//
//  Created by Luma Gabino Vasconcelos on 22/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import Foundation
import MapKit
import CoreData
import Contacts

enum Stage {
    case origin
    case destiny
}

class Path: NSManagedObject {
    @NSManaged public var pathId: UUID?
    @NSManaged public var originLat: NSNumber?
    @NSManaged public var originLong: NSNumber?
    @NSManaged public var originRadius: NSNumber?
    @NSManaged public var destinyLat: NSNumber?
    @NSManaged public var destinyLong: NSNumber?
    @NSManaged public var destinyRadius: NSNumber?
    
    
    convenience init() {
        // get contexts
        let managedObjectContext: NSManagedObjectContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
        
        // create entity description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Path", in: managedObjectContext)
        
        // call super
        self.init(entity: entityDescription!, insertInto: nil)
    }
    
    public func getCircle(stage: Stage) -> MKCircle {
        var circle: MKCircle
        var coordinate: CLLocationCoordinate2D
        var radius: Double
        
        switch stage {
        case .origin:
            let lat = originLat as! Double
            let long = originLong as! Double
            coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            radius = originRadius as! Double
        case .destiny:
            let lat = destinyLat as! Double
            let long = destinyLong as! Double
            coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            radius = destinyRadius as! Double
        }
        
        circle = MKCircle(center: coordinate, radius: radius)
        
        return circle
    }
    
    public func getAddressText(stage: Stage, completion: @escaping (String?, Error?) -> Void) {
        
        var coordinate: CLLocation
        
        switch stage {
        case .origin:
            let lat = originLat as! Double
            let long = originLong as! Double
            coordinate = CLLocation(latitude: lat, longitude: long)
        case .destiny:
            let lat = destinyLat as! Double
            let long = destinyLong as! Double
            coordinate = CLLocation(latitude: lat, longitude: long)
        }
        
        var addressTxt = ""

        CLGeocoder().reverseGeocodeLocation(coordinate, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                //handle error
                completion(nil,error)
            } else if let results = placemarks,
                results.count > 0 {
                let result = results[0]
                
                let postalAddressFormatter = CNPostalAddressFormatter()
                postalAddressFormatter.style = .mailingAddress
                
                if let fullAddress = result.postalAddress {
                    addressTxt = postalAddressFormatter.string(from: fullAddress)
                } else if let city = result.locality, let state = result.administrativeArea {
                    addressTxt = city + ", " + state
                }
                
                completion(addressTxt,nil)
            }
        })
        
    }
    
}

//class PathTest {
//    public var originLat: NSNumber?
//    public var originLong: NSNumber?
//    public var originRadius: NSNumber?
//    public var destinyLat: NSNumber?
//    public var destinyLong: NSNumber?
//    public var destinyRadius: NSNumber?
//
//    init()
//    {
//        originLat = nil
//        originLong = nil
//        originRadius = nil
//        destinyLat = nil
//        destinyLong = nil
//        destinyRadius = nil
//    }
//    
//    public func getCircle(stage: Stage) -> MKCircle {
//        var circle: MKCircle
//        var coordinate: CLLocationCoordinate2D
//        var radius: Double
//        
//        switch stage {
//        case .origin:
//            let lat = originLat as! Double
//            let long = originLong as! Double
//            coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
//            radius = originRadius as! Double
//        case .destiny:
//            let lat = destinyLat as! Double
//            let long = destinyLong as! Double
//            coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
//            radius = originRadius as! Double
//        }
//        
//        circle = MKCircle(center: coordinate, radius: radius)
//        
//        return circle
//    }
//}
