//
//  MapViewManager.swift
//  ManasPelasManas
//
//  Created by Beatriz Viseu Linhares on 27/08/20.
//  Copyright © 2020 Luma Gabino Vasconcelos. All rights reserved.
//

import MapKit

class MapViewManager {
    var mapView: MKMapView

    init(mapView: MKMapView) {
        self.mapView = mapView
        self.disableAccessibility()
    }

    // TODO: Zoom to fit all elements
    func zoomTo(regionA: MKCircle, regionB: MKCircle) -> MKMapRect {
        let boundingArea = (regionA.boundingMapRect).union(regionB.boundingMapRect)
        let padding = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        let newVisibleMapRect = self.mapView.mapRectThatFits(boundingArea, edgePadding: padding)
        return newVisibleMapRect
    }

    // Adds map annotations for start and destination of the route
    func annotationsConfig(circle: MKCircle, subtitle: String) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.subtitle = subtitle
        annotation.coordinate = circle.coordinate

        return annotation
    }

    // MARK: Displaying Map Data
    func displayMapItems(path: Path?) {

        guard let path = path else {
            print("Path is null")
            return
        }

        let pathServices = PathServices()

        let circleA = pathServices.getCircle(path: path, stage: .origin)
        let circleB = pathServices.getCircle(path: path, stage: .destiny)

        let annotationA = self.annotationsConfig(circle: circleA, subtitle: "Starting Point")
        let annotationB = self.annotationsConfig(circle: circleB, subtitle: "Destination Point")

        self.mapView.addAnnotations([annotationA, annotationB])
        self.mapView.addOverlays([circleA, circleB])
        self.mapView.visibleMapRect = self.zoomTo(regionA: circleA, regionB: circleB)
    }

    func disableAccessibility() {
        if UIAccessibility.isVoiceOverRunning {
            self.mapView.accessibilityElementsHidden = true
        }
    }

}
