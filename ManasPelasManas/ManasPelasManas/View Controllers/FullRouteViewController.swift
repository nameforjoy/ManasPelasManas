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
    var journeyDate: String = "laa"
    var earlierLeave: String = "laaa"
    var latestLeave: String = "laaaa"
    
    @IBOutlet weak var journeyTimeTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        
        self.journeyTimeTableView.dataSource = self
        self.journeyTimeTableView.delegate = self
        
        // TODO: Display 2 annotations and 2 overlays

//        addAnnotations()
//        
//        mapView.addAnnotations([annotationA!, annotationB!])
//        mapView.addOverlays([(newPath?.origin)!, (newPath?.destiny)!])
//
//        zoomTo(regionA: newPath!.origin! , regionB: newPath!.destiny!)
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

extension FullRouteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "journeyTimeCell") as! JourneyTimeTableViewCell
        switch indexPath.row {
        case 0:
            cell.leftLabel.text = "Data"
            cell.rightLabel.text = self.journeyDate
        case 1:
            cell.leftLabel.text = "Posso sair a partir das"
            cell.rightLabel.text = self.earlierLeave
        default:
            cell.leftLabel.text = "Preciso sair até as"
            cell.rightLabel.text = self.latestLeave
        }
        return cell
    }
}

extension FullRouteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
}
