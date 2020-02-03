//
//  JourneyDAO.swift
//  ManasPelasManas
//
//  Created by Luma Gabino Vasconcelos on 27/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import UIKit

class JourneyDAO: DAO {
    
    /// Method responsible for saving a guiding data into database
    /// - parameters:
    ///     - objectToBeSaved: guiding data to be saved on database
    /// - throws: if an error occurs during saving an object into database (Errors.DatabaseFailure)
    static func create(_ objectToBeSaved: Journey) throws {
        self.mock.journeys.append(objectToBeSaved)
        
        if self.mock.journeys[self.mock.journeys.count-1] != objectToBeSaved {
            throw Errors.DatabaseFailure
        }
    }
    
    /// Method responsible for updating a guiding data into database
    /// - parameters:
    ///     - objectToBeUpdated: guiding data to be updated on database
    /// - throws: if an error occurs during updating an object into database (Errors.DatabaseFailure)
    static func update(_ objectToBeUpdated: Journey) throws {
//        do {
//            // persist changes at the context
//            try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
//        }
//        catch {
//            throw Errors.DatabaseFailure
//        }
    }
    
    /// Method responsible for deleting a guiding data from database
    /// - parameters:
    ///     - objectToBeSaved: guiding data to be saved on database
    /// - throws: if an error occurs during deleting an object into database (Errors.DatabaseFailure)
    static func delete(_ objectToBeDeleted: Journey) throws {
//        do {
//            // delete element from context
//            CoreDataManager.sharedInstance.persistentContainer.viewContext.delete(objectToBeDeleted)
//
//            // persist the operation
//            try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
//        }
//        catch {
//            throw Errors.DatabaseFailure
//        }
    }
    
    /// Method responsible for retrieving all guiding data from database
    /// - returns: a list of guiding data from database
    /// - throws: if an error occurs during getting an object from database (Errors.DatabaseFailure)
    static func findAll() throws -> [Journey] {
        // list of journeys to be returned
        var journeyList:[Journey] = []
        
        // perform search
        journeyList = mock.journeys

        if journeyList.count != 0 {
            return journeyList
        }
        else {
            throw Errors.DatabaseFailure
        }
    }
    
    static func findById(objectID: UUID) throws -> Journey? {
        var journey: Journey?

        // perform search
        journey = mock.findJourneyById(id: objectID)
        
        if journey != nil {
            return journey
        }
        else {
            throw Errors.DatabaseFailure
        }
    }
}
