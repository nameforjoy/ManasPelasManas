//
//  StartPointViewController.swift
//  ManasPelasManas
//
//  Created by Joyce Simão Clímaco on 21/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

// Ele chama o didChangeAuthorisation quando vc seta a mesma configuração que já estava?

class StartPointViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var initialLocation = CLLocationCoordinate2D()
    var mapRange: Double = 1000.0 // meters
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        checkAuthorizationStatus()
        
        // Sets default initial location
        self.initialLocation = CLLocationCoordinate2D(latitude: -22.8184, longitude: -47.0647)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.centerMapOnLocation(location: initialLocation)
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 2.1 * mapRange, longitudinalMeters: 2.1 * mapRange)
        self.mapView.setRegion(region, animated: true)
    }
}

extension StartPointViewController: CLLocationManagerDelegate {
    
    // Turn on locatioon services or asks for authorization
    func checkAuthorizationStatus() {
        if CLLocationManager.locationServicesEnabled() {
            activateLocationServices()
        }
        else { // Requests user authorization
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // Hamdles changes in authorization status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            activateLocationServices()
        }
    }
    
    // Starts location services
    func activateLocationServices() {
        // We need a high accuracy since our user is by foot, but  not too  much so that too much battery is consumed
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    // Handles location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationCoordinates: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.initialLocation = locationCoordinates
    }
    
}
