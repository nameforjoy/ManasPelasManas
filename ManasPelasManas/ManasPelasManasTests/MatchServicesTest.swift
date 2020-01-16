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
        // Obs: the distance between (latitude, longitude) = (0,0) and (0,0.1) is approximately 11.13 km
        
        let referenceRadius: Double = 10*1000 // radius in meters
        let referenceCircle = MKCircle(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), radius: referenceRadius)
        
        // Match
        let bigRadius: Double = 1.2*1000
        let bigCircle = MKCircle(center: CLLocationCoordinate2D(latitude: 0, longitude: 0.1), radius: bigRadius)
        
        // No match
        let smallRadius: Double = 1.1*1000
        let smallCircle = MKCircle(center: CLLocationCoordinate2D(latitude: 0, longitude: 0.1), radius: smallRadius)
        
        // Limit case
        let limitRadius: Double = 1.14*1000
        let limitCircle = MKCircle(center: CLLocationCoordinate2D(latitude: 0, longitude: 0.1), radius: limitRadius)
        
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
        
        let radius: Double = 10*1000 // radius in meters
        let referenceCircle = MKCircle(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), radius: radius)
        
        let latitudeAboveLimitCircle = MKCircle(center: CLLocationCoordinate2D(latitude: 91, longitude: 0), radius: radius)
        let latitudeBelowLimitCircle = MKCircle(center: CLLocationCoordinate2D(latitude: -91, longitude: 0), radius: radius)
        
        let matchServices = MatchServices()
        
        // Checks for general  error
        XCTAssertThrowsError(try matchServices.checkMatchingRegion(regionA: referenceCircle, regionB: latitudeAboveLimitCircle))
        
        // Checks  for specific error and returns message if no error is encountered
        XCTAssertThrowsError(try matchServices.checkMatchingRegion(regionA: referenceCircle, regionB: latitudeBelowLimitCircle), "Should return latitude outside range error") { (error) in
            XCTAssertEqual(error  as! Errors , .LatitudeOutsideRange)
        }
    }
    
    func testCyclicLongitudeValue() {
        // longitude accepts any value (angle in degrees with cyclic property 360)
        
        let radius: Double = 8*1000 // radius in meters
        let referenceCircle = MKCircle(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), radius: radius)
        
        let longitudeCycleCircle = MKCircle(center: CLLocationCoordinate2D(latitude: 0, longitude: 360+0.1), radius: radius)
        
        let matchServices = MatchServices()

        do {
            let longitudeCycle = try matchServices.checkMatchingRegion(regionA: referenceCircle, regionB: longitudeCycleCircle)
            XCTAssertTrue(longitudeCycle)
        } catch {
            XCTFail()
        }
    }
    
    func testValidRadiusRange() {
        
        let maxRadius: Double = 11*1000
        let minRadius: Double = 0.5*1000
        
        let radius: Double = 10*1000 // radius in meters
        let referenceCircle = MKCircle(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), radius: radius)
        
        let bigRadius: Double = maxRadius + 1
        let smallRadius: Double = minRadius - 1
        
        let bigCircle = MKCircle(center: CLLocationCoordinate2D(latitude: 0, longitude: 0.1), radius: bigRadius)
        let smallCircle = MKCircle(center: CLLocationCoordinate2D(latitude: 0, longitude: 0.1), radius: smallRadius)
        
        let matchServices = MatchServices()
        
        XCTAssertThrowsError(try matchServices.checkMatchingRegion(regionA: bigCircle, regionB: referenceCircle), "Radius above allowed range") { (error) in
            XCTAssertEqual(error as! Errors, .RegionRadiusOutsideTheAllowedRange)
        }
        
        XCTAssertThrowsError(try matchServices.checkMatchingRegion(regionA: smallCircle, regionB: referenceCircle), "Radius  below allowed range") { (error) in
            XCTAssertEqual(error as! Errors, .RegionRadiusOutsideTheAllowedRange)
        }
    }

}
