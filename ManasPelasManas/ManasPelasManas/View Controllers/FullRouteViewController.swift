//
//  FullRouteViewController.swift
//  ManasPelasManas
//
//  Created by Beatriz Viseu Linhares on 26/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import UIKit
import MapKit

class FullRouteViewController: UIViewController {
    var pointA: CLLocationCoordinate2D?
    var pointB: CLLocationCoordinate2D?
    var regionA: CLCircularRegion?
    var regionB: CLCircularRegion?
    let dataSource = LoadData()
    
    override func viewDidLoad() {
        regionA = dataSource.user1.journeys[0].path.origin
        regionB = dataSource.user1.journeys[0].path.destiny
        pointA = regionA?.center
        pointB = regionB?.center
        
        // TODO: Display 2 annotations and 2 overlays
        
        // TODO: Zoom to fit all elements
    }
}
