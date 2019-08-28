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
    
    @objc var newPath: Path?
    @objc var newJourney: Journey?
    var pathId: UUID?
    
    var annotationA: MKPointAnnotation?
    var annotationB: MKPointAnnotation?
    var circleA: MKCircle?
    var circleB: MKCircle?
    
    @IBOutlet weak var mapView: MKMapView!
  
    //    MARK: Trying to retrieve Path by the UUID from the segue
//    override func viewWillAppear(_ animated: Bool) {
//        PathServices.findById(objectID: pathId!) { (error, path) in
//            if (error == nil && path != nil){
//                self.newPath = path
//            } else {
//                //treat error
//            }
//        }
//    }
    
    override func viewDidLoad() {
        // TODO: Display 2 annotations and 2 overlays
        
        circleA = newPath?.getCircle(stage: .origin)
        circleB = newPath?.getCircle(stage: .destiny)
        
        addAnnotations()
        
        mapView.addAnnotations([annotationA!, annotationB!])
        mapView.addOverlays([circleA!, circleB!])

        zoomTo(regionA: circleA!, regionB: circleB!)

    }
    
    @IBAction func confirmButton(_ sender: Any) {
        
        //criar Journey no CoreData
        newJourney = Journey()
        
        //set attributes for newJorney
        //date from datepicker
        //newJourney?.has_path = newPath!
        newJourney?.journeyId = UUID()
        
        JourneyServices.createJourney(journey: newJourney!) { error in
            if (error != nil){
                //treat error
            }
        }
        
    }
    
    private func addAnnotations() {
        annotationA = MKPointAnnotation()
        annotationA!.subtitle = "Starting Point"
        annotationA!.coordinate = circleA!.coordinate
        
        annotationB = MKPointAnnotation()
        annotationB!.subtitle = "Destination Point"
        annotationB!.coordinate = circleB!.coordinate
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
