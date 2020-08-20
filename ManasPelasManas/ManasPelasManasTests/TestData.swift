//
//  TestData.swift
//  ManasPelasManasTests
//
//  Created by Joyce Simão Clímaco on 29/01/20.
//  Copyright © 2020 Luma Gabino Vasconcelos. All rights reserved.
//

import Foundation
import MapKit

class TestData {

    init() {
    }

    //Fazer guards!!
    static func createFomattedDate(date: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return (formatter.date(from: date))!
    }

    func createFormattedHour(hour: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy'T'HH:mm"
        return formatter.date(from: hour)!
    }

    func createCircularRegion(latitude: Double, longitude: Double , radius: Double, reference: String) -> CLCircularRegion {
        
        guard let latitude = CLLocationDegrees(exactly: latitude), let long = CLLocationDegrees(exactly: longitude) else {
            return CLCircularRegion(center: CLLocationCoordinate2D(latitude: -15.792953 , longitude: -47.886961), radius: 100, identifier: "brasilia")
        }
        let radius = CLLocationDistance(exactly: radius)!
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: long)
        let cirularRegion = CLCircularRegion(center: coordinate, radius: radius, identifier: reference)
        return cirularRegion
    }
}
