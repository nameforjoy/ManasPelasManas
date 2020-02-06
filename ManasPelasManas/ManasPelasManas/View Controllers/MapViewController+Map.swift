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

    // This function is called everytime map region is changed by user interaction
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        var radius: Double = self.getCurrentCircularRegion().radius
        self.radiusSlider.setValue(Float(radius), animated: true)
        
        if radius >= 1000 {
            radius = Double(round(10 * radius) / 10000)
            radiusMetersLabel.text = "\(Int(radius))km"
        } else {
            radiusMetersLabel.text = "\(Int(radius))m"
        }
        
        // Does not allow a bigger region span than the value allowed
        if animated == false {
            if self.mapView.region.span.latitudeDelta > self.maxSpan.latitudeDelta || mapView.region.span.longitudeDelta > self.maxSpan.longitudeDelta {
                let region =  MKCoordinateRegion(center: mapView.region.center, span: self.maxSpan)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
}

extension MapViewController {
    
    // Gets current circular region displayed on mao
    func getCurrentCircularRegion() -> MKCircle {
        
        let edge2D: CLLocationCoordinate2D = mapView.convert(CGPoint(x: 0, y: self.radiusImageView.frame.height / 2), toCoordinateFrom: self.radiusImageView)
        let center2D: CLLocationCoordinate2D = mapView.convert(CGPoint(x: self.radiusImageView.frame.width / 2 , y: self.radiusImageView.frame.height / 2), toCoordinateFrom: self.radiusImageView)
        
        let edge = CLLocation(latitude: edge2D.latitude, longitude: edge2D.longitude)
        let center = CLLocation(latitude: center2D.latitude, longitude: center2D.longitude)
        
        let distance: Double = center.distance(from: edge) // meters
        return MKCircle(center: center.coordinate, radius: distance)
    }
    
    // Zooms in to a certain map region
    func zoomMapTo(location: CLLocation) {
        let region =  MKCoordinateRegion(center: location.coordinate, span: self.defaultSpan)
        mapView.setRegion(region, animated: true)
    }
    
    // Centers map on user current location
    func centerMapOnUserLocation() {
        locationManager.requestLocation()
        if let location = locationManager.location {
            self.zoomMapTo(location: location)
        }
    }
}
