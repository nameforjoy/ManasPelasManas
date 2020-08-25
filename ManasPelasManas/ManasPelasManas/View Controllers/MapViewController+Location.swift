//
//  MapViewController+CoreLocation.swift
//  ManasPelasManas
//
//  Created by Joyce Simão Clímaco on 06/02/20.
//  Copyright © 2020 Luma Gabino Vasconcelos. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import MapKit

extension MapViewController: CLLocationManagerDelegate {
    
    // Handles location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.locationReference = location
        }
        self.locationManager.stopUpdatingLocation()
    }
    
    // Shows error message
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    // Hamdles changes in authorization status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorizationStatus()
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            centerMapOnUserLocation()
        }
    }
}

extension MapViewController {
    
    // Starts location services
    func activateLocationServices() {
        // We need a high accuracy since our user is by foot, but  not too  much so that too much battery is consumed
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    // Checks if Location Services are enabled and if not asks for authorization
    func checkAuthorizationStatus() {
        if CLLocationManager.locationServicesEnabled() {
            let status  = CLLocationManager.authorizationStatus()
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                self.activateLocationServices()
            } else if status == .denied || status == .restricted {
                self.presentLocationPermissionAlert()
            } else {
                self.locationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
    // Presents alert if location is turned off
    func presentLocationPermissionAlert() {
        let alertController = UIAlertController(title: "Localização", message: "Seus serviços de localização encontram-se desativados para esse app. Utilizamos  esse serviço para facilitar sua definição  de rota, porém o app pode ser utilizado sem ele normalmente. Caso deseje habilitar sua localização nesse app, basta ligar  esse serviço em suas Configurações.", preferredStyle: .alert)
        
        // Adds settings button action
        let settingsAction = UIAlertAction(title: "Configurações", style: .default) { (_) -> Void in
            
            // Gets the URL for this app's Settings
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            // Opens URL when clicking the button
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (sucess) in
                    print("Settings opened: \(sucess)") // Prints true
                })
            }
        }
        // Adds Cancel button action
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        // Presents Alert
        present(alertController, animated: true, completion: nil)
        
    }
}
