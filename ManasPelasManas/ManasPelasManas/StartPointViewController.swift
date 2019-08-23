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
    
    @IBOutlet weak var radiusView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        self.centerMapOnLocation(location: initialLocation)
        
        // Sets default initial location
        self.initialLocation = CLLocationCoordinate2D(latitude: -22.8184, longitude: -47.0647)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.centerMapOnLocation(location: initialLocation)
    }
    
    @IBAction func nextButton(_ sender: Any) {
        
        let edge2D: CLLocationCoordinate2D = mapView.convert(CGPoint(x: 0, y: self.radiusView.frame.height / 2), toCoordinateFrom: self.radiusView)
        let center2D: CLLocationCoordinate2D = mapView.convert(CGPoint(x: self.radiusView.frame.width / 2 , y: self.radiusView.frame.height / 2), toCoordinateFrom: self.radiusView)
        
        let center = CLLocation(latitude: center2D.latitude, longitude: center2D.longitude)
        let edge = CLLocation(latitude: edge2D.latitude, longitude: edge2D.longitude)
        
        let distance  = center.distance(from: edge)
        print("Radius is \(distance)")
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 2.1 * mapRange, longitudinalMeters: 2.1 * mapRange)
        self.mapView.setRegion(region, animated: true)
    }
    
    func presentAlert() {
        let alertController = UIAlertController (title: "Localização", message: "Seus serviços de localização encontram-se desativados para esse app. Utilizamos  esse serviço para facilitar sua definição  de rota, porém o app pode ser utilizado sem ele normalmente. Caso deseje habilitar sua localização nesse app, basta ligar  esse serviço em suas Configurações.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Configurações", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (sucess) in
                    print("Settings opened: \(sucess)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension StartPointViewController: CLLocationManagerDelegate {
    
    // Hamdles changes in authorization status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            self.activateLocationServices()
        } else if status == .denied || status == .restricted {
            self.presentAlert()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
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
