//
//  PathDAO.swift
//  ManasPelasManas
//
//  Created by Luma Gabino Vasconcelos on 27/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//


import UIKit
import CoreData

class PathDAO: DAO {
    
    /// Method responsible for saving a guiding data into database
    /// - parameters:
    ///     - objectToBeSaved: guiding data to be saved on database
    /// - throws: if an error occurs during saving an object into database (Errors.DatabaseFailure)
    static func create(_ objectToBeSaved: Path) throws {
        do {
            // add object to be saved to the context
            CoreDataManager.sharedInstance.persistentContainer.viewContext.insert(objectToBeSaved)
            
            // persist changes at the context
            try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
        }
        catch {
            throw Errors.DatabaseFailure
        }
    }
    
    /// Method responsible for updating a guiding data into database
    /// - parameters:
    ///     - objectToBeUpdated: guiding data to be updated on database
    /// - throws: if an error occurs during updating an object into database (Errors.DatabaseFailure)
    static func update(_ objectToBeUpdated: Path) throws {
        do {
            // persist changes at the context
            try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
        }
        catch {
            throw Errors.DatabaseFailure
        }
    }
    
    /// Method responsible for deleting a guiding data from database
    /// - parameters:
    ///     - objectToBeSaved: guiding data to be saved on database
    /// - throws: if an error occurs during deleting an object into database (Errors.DatabaseFailure)
    static func delete(_ objectToBeDeleted: Path) throws {
        do {
            // delete element from context
            CoreDataManager.sharedInstance.persistentContainer.viewContext.delete(objectToBeDeleted)
            
            // persist the operation
            try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
        }
        catch {
            throw Errors.DatabaseFailure
        }
    }
    
    /// Method responsible for retrieving all guiding data from database
    /// - returns: a list of guiding data from database
    /// - throws: if an error occurs during getting an object from database (Errors.DatabaseFailure)
    static func findAll() throws -> [Path] {
        // list of guiding data to be returned
        var pathList:[Path]
        
        do {
            // creating fetch request
            let request:NSFetchRequest<Path> = fetchRequest()
            
            // perform search
            pathList = try CoreDataManager.sharedInstance.persistentContainer.viewContext.fetch(request)
        }
        catch {
            throw Errors.DatabaseFailure
        }
        
        return pathList
    }
    
    static func findById(objectID: UUID) throws -> Path? {
        // list of projects to be returned
        var path: [Path]
        
        do {
            // creating fetch request
            let request:NSFetchRequest<Path> = fetchRequest()
            
            request.predicate = NSPredicate(format: "pathId == %@", objectID as CVarArg)
            
            // perform search
            path = try CoreDataManager.sharedInstance.persistentContainer.viewContext.fetch(request)
        }
        catch {
            throw Errors.DatabaseFailure
        }
        
        switch path.count {
        case 1:
            return path[0]
        default:
            throw Errors.DatabaseFailure
        }
    }
}
