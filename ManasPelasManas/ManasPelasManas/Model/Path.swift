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
    
//    init () {
//    }
//
//    init (pathId: Int, origin: MKCircle, destiny: MKCircle) {
//        self.pathId = pathId
//        self.origin = origin
//        self.destiny = destiny
//    }
    
    
}
