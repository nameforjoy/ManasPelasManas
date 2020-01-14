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
    
    // REGION
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let  circleA = MKCircle(center: CLLocationCoordinate2D(latitude: 10, longitude: 10), radius: 100)
        let  circleB = MKCircle(center: CLLocationCoordinate2D(latitude: 5, longitude: 5), radius: 1000)
        
        let matchServices = MatchServices()
        
        let result = matchServices.checkMatchingRegion(regionA: circleA, regionB: circleB)
        
        XCTAssertFalse(result)
    }

    // TIME RANGE
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // JOURNEY

}
