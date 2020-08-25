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
            XCTFail("Value obtained by algorithm does not correspond to actual distance between the two places being tested")
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
            if let error = error as? Errors {
                XCTAssertEqual(error, .latitudeOutsideRange)
            } else {
                XCTFail("Error should be Errors instance")
            }
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
            XCTFail("Longitude not accepting values outside of range [0, 360]")
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
            if let error = error as? Errors {
                XCTAssertEqual(error, .regionRadiusOutsideTheAllowedRange)
            } else {
                XCTFail("Error should be Errors instance")
            }
        }
        
        XCTAssertThrowsError(try matchServices.checkMatchingRegion(regionA: smallCircle, regionB: referenceCircle), "Radius  below allowed range") { (error) in
            if let error = error as? Errors {
                XCTAssertEqual(error, .regionRadiusOutsideTheAllowedRange)
            } else {
                XCTFail("Error should be Errors instance")
            }
        }
    }
    
    // TIME RANGE
        func testIntervalsWithIntersectionTimetable() {
            let journeyA = Journey()
            let journeyB = Journey()
        
            let testData = TestData()
            let initialHourA = testData.createFormattedHour(hour: "30/08/2019T07:30")
            let finalHourA = testData.createFormattedHour(hour: "30/08/2019T08:00")
            let initialHourB = testData.createFormattedHour(hour: "30/08/2019T07:45")
            let finalHourB = testData.createFormattedHour(hour: "30/08/2019T08:30")
            
            journeyA.initialHour = initialHourA
            journeyA.finalHour = finalHourA
            journeyB.initialHour = initialHourB
            journeyB.finalHour = finalHourB
            
            let matchServices = MatchServices()
            let result = matchServices.checkMatchTimetable(journeyA: journeyA, journeyB: journeyB)
            
            XCTAssertTrue(result)
        }
        
        func testIntervalsWithoutIntersectionTimetable() {
             let journeyA = Journey()
             let journeyB = Journey()
         
             let testData = TestData()
             let initialHourA = testData.createFormattedHour(hour: "30/08/2019T07:30")
             let finalHourA = testData.createFormattedHour(hour: "30/08/2019T08:00")
             let initialHourB = testData.createFormattedHour(hour: "30/08/2019T10:45")
             let finalHourB = testData.createFormattedHour(hour: "30/08/2019T11:30")
             
             journeyA.initialHour = initialHourA
             journeyA.finalHour = finalHourA
             journeyB.initialHour = initialHourB
             journeyB.finalHour = finalHourB
             
             let matchServices = MatchServices()
             let result = matchServices.checkMatchTimetable(journeyA: journeyA, journeyB: journeyB)
             
             XCTAssertFalse(result)
         }
        
        func testInitialAndFinalHourSwichedWithoutIntersection() {
            let journeyA = Journey()
            let journeyB = Journey()

            let testData = TestData()
            let initialHourA = testData.createFormattedHour(hour: "30/08/2019T08:00")
            let finalHourA = testData.createFormattedHour(hour: "30/08/2019T07:30")
            let initialHourB = testData.createFormattedHour(hour: "30/08/2019T10:45")
            let finalHourB = testData.createFormattedHour(hour: "30/08/2019T11:30")

            journeyA.initialHour = initialHourA
            journeyA.finalHour = finalHourA
            journeyB.initialHour = initialHourB
            journeyB.finalHour = finalHourB

            let matchServices = MatchServices()
            let result = matchServices.checkMatchTimetable(journeyA: journeyA, journeyB: journeyB)

            XCTAssertFalse(result)
         }
        
        //Verificar intervalos de tempo inválidos
        func testInitialAndFinalHourSwichedWithIntersection() {
            let journeyA = Journey()
            let journeyB = Journey()

            let testData = TestData()
            let initialHourA = testData.createFormattedHour(hour: "30/08/2019T08:00")
            let finalHourA = testData.createFormattedHour(hour: "30/08/2019T07:30")
            let initialHourB = testData.createFormattedHour(hour: "30/08/2019T07:45")
            let finalHourB = testData.createFormattedHour(hour: "30/08/2019T08:30")

            journeyA.initialHour = initialHourA
            journeyA.finalHour = finalHourA
            journeyB.initialHour = initialHourB
            journeyB.finalHour = finalHourB

            let matchServices = MatchServices()
            let result = matchServices.checkMatchTimetable(journeyA: journeyA, journeyB: journeyB)

            XCTAssertFalse(result)
         }
        
    //    As datas são escolhidas por date picker logo irei considerar impossível a seleção de uma data inválida para anos não bissextos
        func testTrueLeapYearWithIntersection() {
            let journeyA = Journey()
            let journeyB = Journey()
        
            let testData = TestData()
            let initialHourA = testData.createFormattedHour(hour: "29/02/2020T10:00")
            let finalHourA = testData.createFormattedHour(hour: "29/02/2020T12:30")
            let initialHourB = testData.createFormattedHour(hour: "29/02/2020T11:00")
            let finalHourB = testData.createFormattedHour(hour: "29/02/2020T12:30")
            
            journeyA.initialHour = initialHourA
            journeyA.finalHour = finalHourA
            journeyB.initialHour = initialHourB
            journeyB.finalHour = finalHourB
            
            let matchServices = MatchServices()
            let result = matchServices.checkMatchTimetable(journeyA: journeyA, journeyB: journeyB)
            
            XCTAssertTrue(result)
        }

}
