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
    
    var newPath: Path?
    var annotationA: MKPointAnnotation?
    var annotationB: MKPointAnnotation?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        
        // TODO: Display 2 annotations and 2 overlays

        addAnnotations()
        
        mapView.addAnnotations([annotationA!, annotationB!])
        mapView.addOverlays([(newPath?.origin)!, (newPath?.destiny)!])

        zoomTo(regionA: newPath!.origin! , regionB: newPath!.destiny!)

    }
    
    private func addAnnotations() {
        annotationA = MKPointAnnotation()
        annotationA!.subtitle = "Starting Point"
        annotationA!.coordinate = (newPath?.origin!.coordinate)!
        
        annotationB = MKPointAnnotation()
        annotationB!.subtitle = "Destination Point"
        annotationB!.coordinate = (newPath?.destiny!.coordinate)!
    }
    
    // TODO: Zoom tofit all elements

    private func zoomTo(regionA: MKCircle, regionB: MKCircle) {
        let boundingArea = (regionA.boundingMapRect).union(regionB.boundingMapRect)
        let padding = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        mapView.visibleMapRect = mapView.mapRectThatFits(boundingArea, edgePadding: padding)
    }
    
}

// MARK: Defining Appearance for Circle Regions
extension FullRouteViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if (overlay is MKCircle) {
            let circleRender = MKCircleRenderer(overlay: overlay)
            circleRender.fillColor = UIColor(hue: 9/360, saturation: 66/100, brightness: 92/100, alpha: 0.5)
            circleRender.lineWidth = 10
            
            return circleRender
        }
        
        return MKPolylineRenderer()
    }
}
