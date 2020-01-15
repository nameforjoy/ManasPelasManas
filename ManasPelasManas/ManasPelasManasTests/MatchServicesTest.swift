//
//  MatchServicesTest.swift
//  ManasPelasManasTests
//
//  Created by Joyce Simão Clímaco on 14/01/20.
//  Copyright © 2020 Luma Gabino Vasconcelos. All rights reserved.
//

import XCTest
import MapKit

@testable import ManasPelasManas

class MatchServicesTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // Inicializar dados/serviços
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        // Apaga arquivos/dados criados só pro teste, finaliza serviços
    }
    
    // MARK: Region
    
    func testRegionsMatch() {
        // Test simple region match cases
        // Obs: the distance between (latitude, longitude) = (11,10) and (10,10) is approximately 111 km
        
        let bigRadius: Double = 100*1000 // radius in meters
        let referenceCircle = MKCircle(center: CLLocationCoordinate2D(latitude: 10, longitude: 10), radius: bigRadius)
        
        // Match
        let bigCircle = MKCircle(center: CLLocationCoordinate2D(latitude: 11, longitude: 10), radius: bigRadius)
        
        // No match
        let smallRadius: Double = 10*1000
        let smallCircle = MKCircle(center: CLLocationCoordinate2D(latitude: 11, longitude: 10), radius: smallRadius)
        
        // Limit case
        let limitRadius: Double = 11*1000
        let limitCircle = MKCircle(center: CLLocationCoordinate2D(latitude: 11, longitude: 10), radius: limitRadius)
        
        let matchServices = MatchServices()
        
        do {
            let matchCase = try matchServices.checkMatchingRegion(regionA: bigCircle, regionB: referenceCircle)
            let noMatchCase = try matchServices.checkMatchingRegion(regionA: smallCircle, regionB: referenceCircle)
            let limitCase = try matchServices.checkMatchingRegion(regionA: limitCircle, regionB: referenceCircle)
            
            XCTAssertTrue(matchCase)
            XCTAssertFalse(noMatchCase)
            XCTAssertTrue(limitCase)
        } catch {
            XCTFail()
        }
    }
    
    func testLatitudeRange() {
        // latitude range = [-90, 90]degrees running East-West
        
        let radius: Double = 100*1000 // radius in meters
        let referenceCircle = MKCircle(center: CLLocationCoordinate2D(latitude: 10, longitude: 10), radius: radius)
        
        let latitudeAboveLimitCircle = MKCircle(center: CLLocationCoordinate2D(latitude: -91, longitude: 10), radius: radius)
        let latitudeBelowLimitCircle = MKCircle(center: CLLocationCoordinate2D(latitude: -91, longitude: 10), radius: radius)
        
        let matchServices = MatchServices()
        
        // Checks for general  error
        XCTAssertThrowsError(try matchServices.checkMatchingRegion(regionA: referenceCircle, regionB: latitudeAboveLimitCircle), "Should return latitude outside range error") { (error) in
            XCTAssertEqual(error  as! Errors , .LatitudeOutsideRange)
        }
        
        // Checks  for specific error and returns message if no error is encountered
        XCTAssertThrowsError(try matchServices.checkMatchingRegion(regionA: referenceCircle, regionB: latitudeBelowLimitCircle), "Should return latitude outside range error") { (error) in
            XCTAssertEqual(error  as! Errors , .LatitudeOutsideRange)
        }
    }
    
    func testCyclicLongitudeValue() {
        // longitude accepts any value (angle in degrees with cyclic property 360)
        
        let radius: Double = 1000 // radius in meters
        let referenceCircle = MKCircle(center: CLLocationCoordinate2D(latitude: 10, longitude: 10), radius: radius)
        
        let longitudeCycleCircle = MKCircle(center: CLLocationCoordinate2D(latitude: 10, longitude: 360+10), radius: radius)
        
        let matchServices = MatchServices()

        do {
            let longitudeCycle = try matchServices.checkMatchingRegion(regionA: referenceCircle, regionB: longitudeCycleCircle)
            XCTAssertTrue(longitudeCycle)
        } catch {
            XCTFail()
        }
    }

}
