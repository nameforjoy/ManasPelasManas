//
//  MapViewController+MapKit.swift
//  ManasPelasManas
//
//  Created by Joyce Simão Clímaco on 06/02/20.
//  Copyright © 2020 Luma Gabino Vasconcelos. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate {
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        
        // SÓ SE O SLIDER NÃO  ESTIVER MUDANDO - COLOCAR IF
        let radius: Double = self.getCurrentCircularRegion().radius
        // self.radiusSlider.setValue(Float(radius), animated: true)
        self.updateRadiusLabel(radius: radius)
    }
}

extension MapViewController {
    
    func updateRadiusLabel(radius: Double) {
        
        if radius >= self.maxRadius {
            self.radiusMetersLabel.text = "\(round(self.maxRadius/100) / 10)km"
        } else if radius >= 1000 {
            self.radiusMetersLabel.text = "\(round(radius/100) / 10)km"
        } else {
            self.radiusMetersLabel.text = "\(Int(radius))m"
        }
    }
    
    // Gets current circular region displayed on mao
    func getCurrentCircularRegion() -> MKCircle {
        
        // NAO NAO NAO NAO NAO NAO
        let edge2D: CLLocationCoordinate2D = mapView.convert(CGPoint(x: 0, y: self.radiusImageView.frame.height / 2), toCoordinateFrom: self.radiusImageView)
        let center2D: CLLocationCoordinate2D = mapView.convert(CGPoint(x: self.radiusImageView.frame.width / 2 , y: self.radiusImageView.frame.height / 2), toCoordinateFrom: self.radiusImageView)
        
        let edge = CLLocation(latitude: edge2D.latitude, longitude: edge2D.longitude)
        let center = CLLocation(latitude: center2D.latitude, longitude: center2D.longitude)
        
        let distance: Double = center.distance(from: edge) // meters
        return MKCircle(center: center.coordinate, radius: distance)
    }
    
    // Zooms in to a certain map region
    func zoomMapTo(location: CLLocation) {
        let region =  MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: self.defaultRadius/0.9, longitudinalMeters: self.defaultRadius/0.9)
        mapView.setRegion(region, animated: true)
    }
    
    // Centers map on user current location
    func centerMapOnUserLocation() {
        locationManager.requestLocation()
        if let location = locationManager.location {
            self.zoomMapTo(location: location)
        }
    }
    
    func zoomMapWithSlider(sliderRadius: Double) {
        let currentCenter: CLLocationCoordinate2D = mapView.centerCoordinate
        let region =  MKCoordinateRegion.init(center: currentCenter, latitudinalMeters: sliderRadius/0.9, longitudinalMeters: sliderRadius/0.9)
        mapView.setRegion(region, animated: false)
    }
}
