//
//  Journey.swift
//  ManasPelasManas
//
//  Created by Luma Gabino Vasconcelos on 22/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import Foundation
import CoreData

class Journey: NSManagedObject {
    @NSManaged public var ownerId: UUID?
    @NSManaged public var journeyId: UUID?
    @NSManaged public var has_path: Path
    @NSManaged public var date: Date?
    @NSManaged public var initialHour: Date?
    @NSManaged public var finalHour: Date?
    @NSManaged public var status: String?
    @NSManaged public var has_confirmed_partners: Set<User>
    @NSManaged public var has_requested_parteners: Set<User>
    
    convenience init() {
        // get context
        let managedObjectContext: NSManagedObjectContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
        
        // create entity description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Journey", in: managedObjectContext)
        
        // call super
        self.init(entity: entityDescription!, insertInto: nil)
    }
}
