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
        
        let radius: Double = self.getCurrentCircularRegion().radius
        
        if radius > self.maxRadius*1.05 {
            let newDistanceSpan = self.maxRadius*2/0.9
            limitRadiusInMap(newDistanceSpan: newDistanceSpan)
        } else if radius < self.minRadius*0.98 {
            let newDistanceSpan = self.minRadius*2/0.9
            limitRadiusInMap(newDistanceSpan: newDistanceSpan)
        } else {
            self.updateRadiusLabel(radius: radius)
            if !self.isTouchingSlider {
                self.radiusSlider.setValue(Float(radius), animated: true)
            }
        }
        
        setupAccessibilityRaduis()
    }
    
    func setupAccessibilityRaduis() {
        // VoiceOver config for radius
        self.radiusMetersLabel.isAccessibilityElement = false
        self.radiusTitleLabel.isAccessibilityElement = false
        self.radiusSlider.isAccessibilityElement = true
        self.radiusSlider.accessibilityLabel = "Raio de deslocamento: \(self.radiusMetersLabel.text!). Ajuste o slider para aumentar ou diminuir o raio."
        self.radiusSlider.accessibilityValue = "\(self.radiusMetersLabel.text!)"
    }
    
}

extension MapViewController {
    
    func limitRadiusInMap(newDistanceSpan: Double) {
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        let region =  MKCoordinateRegion.init(center: mapView.centerCoordinate, latitudinalMeters: newDistanceSpan, longitudinalMeters: newDistanceSpan)
        mapView.setRegion(region, animated: false)
    }
    
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
        
        let edge2D: CLLocationCoordinate2D = mapView.convert(CGPoint(x: 0, y: self.radiusImageView.frame.height / 2), toCoordinateFrom: self.radiusImageView)
        let center2D: CLLocationCoordinate2D = mapView.convert(CGPoint(x: self.radiusImageView.frame.width / 2 , y: self.radiusImageView.frame.height / 2), toCoordinateFrom: self.radiusImageView)
        
        let edge = CLLocation(latitude: edge2D.latitude, longitude: edge2D.longitude)
        let center = CLLocation(latitude: center2D.latitude, longitude: center2D.longitude)
        
        let distance: Double = center.distance(from: edge) // meters
        return MKCircle(center: center.coordinate, radius: distance)
    }
    
    // Centers map on user current location
    func centerMapOnUserLocation() {
        locationManager.requestLocation()
        if let location = locationManager.location {
            let distanceSpan = self.defaultRadius*2/0.9
            let region =  MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: distanceSpan, longitudinalMeters: distanceSpan)
            mapView.setRegion(region, animated: false)
        }
    }
    
    func zoomMapWithSlider(sliderRadius: Double) {
        let distanceSpan = sliderRadius*2/0.9
        let region =  MKCoordinateRegion.init(center: mapView.centerCoordinate, latitudinalMeters: distanceSpan, longitudinalMeters: distanceSpan)
        mapView.setRegion(region, animated: false)
    }
}
