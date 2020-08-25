//
//  PathServices.swift
//  ManasPelasManas
//
//  Created by Luma Gabino Vasconcelos on 27/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class PathServices {
    
    /// Function responsible for creating a project
    /// - parameters:
    ///     - project: Project to be saved
    ///     - completion: closure to be executed at the end of this method
    /// - throws: if an error occurs during saving an object into database (Errors.DatabaseFailure)
    static func createPath(path: Path, _ completion: ((_ error: Error?) -> Void)?) {
        // block to be executed in background
        let blockForExecutionInBackground: BlockOperation = BlockOperation(block: {
            // error to be returned in case of failure
            var raisedError: Error?
            
            do { // save information
                try PathDAO.create(path)
            } catch let error {
                raisedError = error
            }
            
            // completion block execution
            if (completion != nil) {
                let blockForExecutionInMain: BlockOperation = BlockOperation(block: {completion!(raisedError)})
                
                // execute block in main
                QueueManager.sharedInstance.executeBlock(blockForExecutionInMain, queueType: QueueManager.QueueType.main)
            }
        })
        
        // execute block in background
        QueueManager.sharedInstance.executeBlock(blockForExecutionInBackground, queueType: QueueManager.QueueType.serial)
    }
    
    /// Function responsible for updating a project
    /// - parameters:
    ///     - project: Project to be updated
    ///     - completion: closure to be executed at the end of this method
    /// - throws: if an error occurs during saving an object into database (Errors.DatabaseFailure)
    static func updatePath(path: Path, _ completion: ((_ error: Error?) -> Void)?) {
        // block to be executed in background
        let blockForExecutionInBackground: BlockOperation = BlockOperation(block: {
            // error to be returned in case of failure
            var raisedError: Error?
            
            do { // save information
                try PathDAO.update(path)
            } catch let error {
                raisedError = error
            }
            
            // completion block execution
            if (completion != nil) {
                let blockForExecutionInMain: BlockOperation = BlockOperation(block: {completion!(raisedError)})
                
                // execute block in main
                QueueManager.sharedInstance.executeBlock(blockForExecutionInMain, queueType: QueueManager.QueueType.main)
            }
        })
        
        // execute block in background
        QueueManager.sharedInstance.executeBlock(blockForExecutionInBackground, queueType: QueueManager.QueueType.serial)
    }
    
    /// Function responsible for deleting a project
    /// - parameters:
    ///     - project: Project to be deleted
    ///     - completion: closure to be executed at the end of this method
    /// - throws: if an error occurs during saving an object into database (Errors.DatabaseFailure)
    static func deletePath(path: Path, _ completion: ((_ error: Error?) -> Void)?) {
        // block to be executed in background
        let blockForExecutionInBackground: BlockOperation = BlockOperation(block: {
            // error to be returned in case of failure
            var raisedError: Error?
            
            do { // save information
                try PathDAO.delete(path)
            } catch let error {
                raisedError = error
            }
            
            // completion block execution
            if (completion != nil) {
                let blockForExecutionInMain: BlockOperation = BlockOperation(block: {completion!(raisedError)})
                
                // execute block in main
                QueueManager.sharedInstance.executeBlock(blockForExecutionInMain, queueType: QueueManager.QueueType.main)
            }
        })
        
        // execute block in background
        QueueManager.sharedInstance.executeBlock(blockForExecutionInBackground, queueType: QueueManager.QueueType.serial)
    }
    
    /// Function responsible for getting all projects
    /// - parameters:
    ///     - completion: closure to be executed at the end of this method
    /// - throws: if an error occurs during getting an object from database (Errors.DatabaseFailure)
    static func getAllPaths(_ completion: ((_ error: Error?, _ paths: [Path]?) -> Void)?) {
        // block to be executed in background
        let blockForExecutionInBackground: BlockOperation = BlockOperation(block: {
            // error to be returned in case of failure
            var raisedError: Error?
            var paths: [Path]?
            
            do { // save information
                paths = try PathDAO.findAll()
            } catch let error {
                raisedError = error
            }
            
            // completion block execution
            if (completion != nil) {
                let blockForExecutionInMain: BlockOperation = BlockOperation(block: {completion!(raisedError, paths)})
                
                // execute block in main
                QueueManager.sharedInstance.executeBlock(blockForExecutionInMain, queueType: QueueManager.QueueType.main)
            }
        })
        
        // execute block in background
        QueueManager.sharedInstance.executeBlock(blockForExecutionInBackground, queueType: QueueManager.QueueType.serial)
    }
    
    static func findById(objectID: UUID , _ completion: ((_ error: Error?, _ path: Path?) -> Void)?) {
        // block to be executed in background
        let blockForExecutionInBackground: BlockOperation = BlockOperation(block: {
            // error to be returned in case of failure
            var raisedError: Error?
            var path: Path?
            
            do { // save information
                path = try PathDAO.findById(objectID: objectID)
            } catch let error {
                raisedError = error
            }
            
            // completion block execution
            if (completion != nil) {
                let blockForExecutionInMain: BlockOperation = BlockOperation(block: {completion!(raisedError, path)})
                
                // execute block in main
                QueueManager.sharedInstance.executeBlock(blockForExecutionInMain, queueType: QueueManager.QueueType.main)
            }
        })
        
        // execute block in background
        QueueManager.sharedInstance.executeBlock(blockForExecutionInBackground, queueType: QueueManager.QueueType.serial)
    }
    
    public func getCircle(path: Path, stage: Stage) -> MKCircle {
        var circle: MKCircle
        var coordinate: CLLocationCoordinate2D
        var radius: Double
        
        switch stage {
        case .origin:
            let latitude = path.originLat!
            let longitude = path.originLong!
            coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            radius = path.originRadius!
        case .destiny:
            let latitude = path.destinyLat!
            let longitude = path.destinyLong!
            coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            radius = path.destinyRadius!
        }
        
        circle = MKCircle(center: coordinate, radius: radius)
        
        return circle
    }
    
    public func getAddressText(path: Path, stage: Stage, completion: @escaping (String?, Error?) -> Void) {
        
        var coordinate: CLLocation
        
        switch stage {
        case .origin:
            let latitude = path.originLat!
            let longitude = path.originLong!
            coordinate = CLLocation(latitude: latitude, longitude: longitude)
        case .destiny:
            let latitude = path.destinyLat!
            let longitude = path.destinyLong!
            coordinate = CLLocation(latitude: latitude, longitude: longitude)
        }
        
        var addressTxt = ""

        CLGeocoder().reverseGeocodeLocation(coordinate, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                //handle error
                completion(nil,error)
            } else if let results = placemarks,
                !results.isEmpty {
                let result = results[0]
                
                let postalAddressFormatter = CNPostalAddressFormatter()
                postalAddressFormatter.style = .mailingAddress
                
                if let fullAddress = result.postalAddress?.street {
                    addressTxt = fullAddress
                } else if let city = result.locality, let state = result.administrativeArea {
                    addressTxt = city + ", " + state
                }
                
                completion(addressTxt,nil)
            }
        })
    }
    
}
