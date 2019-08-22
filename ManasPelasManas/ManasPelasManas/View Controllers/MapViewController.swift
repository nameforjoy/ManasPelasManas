//
//  MapViewController.swift
//  ManasPelasManas
//
//  Created by Beatriz Viseu Linhares on 21/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    let regionRadius: CLLocationDistance = 1000

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        mapView.setCamera(mapView.camera, animated: true)
        
        self.centerMapOnLocation(location: initialLocation)
        
        mapView.delegate = self

    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}



extension MapViewController: MKMapViewDelegate {
    //delegate  functions
}
