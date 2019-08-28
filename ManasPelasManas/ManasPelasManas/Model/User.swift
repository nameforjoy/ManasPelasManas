//
//  User.swift
//  ManasPelasManas
//
//  Created by Luma Gabino Vasconcelos on 22/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {
    @NSManaged public var userId: UUID?
    @NSManaged public var name: String?
    @NSManaged public var bio: String?
    @NSManaged public var bornDate: Date?
    @NSManaged public var authenticated: NSNumber?
    @NSManaged public var photo: String?
    @NSManaged public var has_journeys: Set<Journey>?
    
    convenience init() {
        // get context
        let managedObjectContext: NSManagedObjectContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
        
        // create entity description
        let entityDescription = NSEntityDescription.entity(forEntityName: "User", in: managedObjectContext)
        
        // call super
        self.init(entity: entityDescription!, insertInto: nil)
    }
    

    
}

// MARK: Generated accessors for has_journeys
//extension User {
//
//    @objc(addHas_journeysObject:)
//    @NSManaged public func addToHas_journeys(_ value: Journey)
//    
//    @objc(removeHas_journeysObject:)
//    @NSManaged public func removeFromHas_journeys(_ value: Journey)
//
//    @objc(addHas_journeys:)
//    @NSManaged public func addToHas_journeys(_ values: NSSet)
//
//    @objc(removeHas_journeys:)
//    @NSManaged public func removeFromHas_journeys(_ values: NSSet)
//
//}



//import Foundation
//import CoreData
//
//
//extension User {
//
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
//        return NSFetchRequest<User>(entityName: "User")
//    }
//
//    @NSManaged public var authenticated: Bool
//    @NSManaged public var bio: String?
//    @NSManaged public var bornDate: NSDate?
//    @NSManaged public var name: String?
//    @NSManaged public var photo: String?
//    @NSManaged public var userId: UUID?
//    @NSManaged public var belongs_to_cofirmed: Journeys?
//    @NSManaged public var belongs_to_requested: Journeys?
//    @NSManaged public var has_journeys: NSSet?
//
//}
//
//// MARK: Generated accessors for has_journeys
//extension User {
//
//    @objc(addHas_journeysObject:)
//    @NSManaged public func addToHas_journeys(_ value: Journeys)
//
//    @objc(removeHas_journeysObject:)
//    @NSManaged public func removeFromHas_journeys(_ value: Journeys)
//
//    @objc(addHas_journeys:)
//    @NSManaged public func addToHas_journeys(_ values: NSSet)
//
//    @objc(removeHas_journeys:)
//    @NSManaged public func removeFromHas_journeys(_ values: NSSet)
//
//}
