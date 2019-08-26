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
    
    var annotationA: MKPointAnnotation?
    var annotationB: MKPointAnnotation?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        // TODO: Display 2 annotations and 2 overlays

        regionA = dataSource.user1.journeys[0].path.origin
        regionB = dataSource.user1.journeys[0].path.destiny
        pointA = regionA?.center
        pointB = regionB?.center
        
        let regionOverlayA = MKCircle(center: pointA!, radius: regionA!.radius)
        let regionOverlayB = MKCircle(center: pointB!, radius: regionB!.radius)

        addAnnotations()
        
        mapView.addAnnotations([annotationA!, annotationB!])
        mapView.addOverlays([regionOverlayA, regionOverlayB])

        // TODO: Zoom tofit all elements
        
        // Code Here
    }
    
    private func addAnnotations() {
        annotationA = MKPointAnnotation()
        annotationA!.subtitle = "Eldorado"
        annotationA!.coordinate = pointA!
        
        annotationB = MKPointAnnotation()
        annotationB!.subtitle = "Av. 3"
        annotationB!.coordinate = pointB!
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
