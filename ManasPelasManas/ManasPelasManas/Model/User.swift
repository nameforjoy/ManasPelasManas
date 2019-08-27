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
    @NSManaged public var has_journeys: Journey?
    
    convenience init() {
        // get context
        let managedObjectContext: NSManagedObjectContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
        
        // create entity description
        let entityDescription = NSEntityDescription.entity(forEntityName: "User", in: managedObjectContext)
        
        // call super
        self.init(entity: entityDescription!, insertInto: nil)
    }
    
    //    init (userId: UUID, name: String, bio: String, bornDate: Date, photo: String, authenticated: Bool) {
    //        self.name = name
    //        self.bio = bio
    //        self.bornDate = bornDate
    //        self.photo = photo
    //        self.authenticated = authenticated
    //        self.userId = userId
    //        self.journeys = [Journey]()
    //    }
    
}
