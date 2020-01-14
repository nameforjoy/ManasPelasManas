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
        
        let radius: Double = 100*1000 // radius in meters
        let  circleA = MKCircle(center: CLLocationCoordinate2D(latitude: 11, longitude: 10), radius: radius)
        let  circleB = MKCircle(center: CLLocationCoordinate2D(latitude: 10, longitude: 10), radius: radius)
        // distance between (11,10) and (10,10) = 111 km
        
        let matchServices = MatchServices()
        let result = matchServices.checkMatchingRegion(regionA: circleA, regionB: circleB)
        
        XCTAssertTrue(result)
    }
    
    func testRegionsDoNotMatch() {
        
        let radius: Double = 10*1000 // radius in meters
        let  circleA = MKCircle(center: CLLocationCoordinate2D(latitude: 11, longitude: 10), radius: radius)
        let  circleB = MKCircle(center: CLLocationCoordinate2D(latitude: 10, longitude: 10), radius: radius)
        // distance between (11,10) and (10,10) = 111 km
        
        let matchServices = MatchServices()
        let result = matchServices.checkMatchingRegion(regionA: circleA, regionB: circleB)
        
        XCTAssertFalse(result)
    }
    
    // Latitude limit
    
    // latitude or longitude coordinate in degrees under the WGS 84 reference
    // frame. The degree can be positive (North and East) or negative (South and West).
    
    func testLatitudeLimitMatch() {
        // Latitude (North/South) exists between -90 and 90 degrees
        
        let  circleA = MKCircle(center: CLLocationCoordinate2D(latitude: 90, longitude: 10), radius: 10000)
        let  circleB = MKCircle(center: CLLocationCoordinate2D(latitude: 10, longitude: 10), radius: 10000)
        
        let matchServices = MatchServices()
        
        let result = matchServices.checkMatchingRegion(regionA: circleA, regionB: circleB)
        
        XCTAssertFalse(result)
    }

}
