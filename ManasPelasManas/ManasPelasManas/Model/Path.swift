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
            radius = originRadius as! Double
        }
        
        circle = MKCircle(center: coordinate, radius: radius)
        
        return circle
    }
    
    
}
