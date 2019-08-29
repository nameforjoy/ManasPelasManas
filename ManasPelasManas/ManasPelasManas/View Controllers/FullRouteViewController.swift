//
//  FullRouteViewController.swift
//  ManasPelasManas
//
//  Created by Beatriz Viseu Linhares on 26/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class FullRouteViewController: UIViewController {
    
    @objc var currentUser: User?
    @objc var newPath: Path?
    @objc var newJourney: Journey?
    var pathId: UUID?
    
    var annotationA: MKPointAnnotation?
    var annotationB: MKPointAnnotation?
    var earlierLeave: String? = nil
    var latestLeave: String? = nil
    var selectedFirstCell: Bool = true
    let maxTimeDifferenceInHours: Double = 8
    var circleA: MKCircle?
    var circleB: MKCircle?
    
    var earlierDate: Date?
    var latestDate: Date?
    
    @IBOutlet weak var journeyTimeTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tapView: UIView!
    
    override func viewDidLoad() {
        
        self.journeyTimeTableView.dataSource = self
        self.journeyTimeTableView.delegate = self
        self.journeyTimeTableView.allowsMultipleSelection = false
        self.journeyTimeTableView.isScrollEnabled = false
        
        self.datePicker.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FullRouteViewController.viewTapped(gestureRecognizer:)))
        self.tapView.addGestureRecognizer(tapGesture)
        self.tapView.isUserInteractionEnabled = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // MARK: Retrieving Path - Core Data
        PathServices.findById(objectID: pathId!) { (error, path) in
            if (error == nil && path != nil){
                self.newPath = path
                self.displayMapItems(path: path)
            } else {
                //treat error
            }
        }
        
        // MARK: Retrieving Authenticated User - Core Data
        UserServices.getAuthenticatedUser { (error, user) in
            if (error == nil && user != nil) {
                self.currentUser = user
            } else {
                //treat error
            }
        }
        
    }

 
    
    // MARK: Displaying Map Data
    
    func displayMapItems(path: Path?) {
        
        self.circleA = path?.getCircle(stage: .origin)
        self.circleB = path?.getCircle(stage: .destiny)
        
        self.addAnnotations()
        
        self.mapView.addAnnotations([annotationA!, annotationB!])
        self.mapView.addOverlays([self.circleA!, self.circleB!])
        
        self.zoomTo(regionA: self.circleA!, regionB: self.circleB!)
    }
    
    // MARK: DatePicker Setup
    
    func datePickerConfig() {
        datePicker?.datePickerMode = .dateAndTime
        datePicker?.backgroundColor = .white
        datePicker?.addTarget(self, action: #selector(FullRouteViewController.dateChanged(datePicker: )), for: .valueChanged)
        datePicker?.isHidden = false

        // Set minimum and maximum date
        datePicker.minimumDate = Date()
        
        // Setting date limits
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, HH:mm"
        datePicker.minimumDate = Date()
        
        // Do not let time range be bigger than self.maxTimeDifferenceInHours for security reasons
        if self.selectedFirstCell && self.latestLeave != nil {
            datePicker.maximumDate = DateFormatter().date(from: self.latestLeave!)
        }
        else if !self.selectedFirstCell && self.earlierLeave != nil {
            datePicker.minimumDate = DateFormatter().date(from: self.earlierLeave!)
        }
        datePicker.maximumDate = datePicker.minimumDate?.addingTimeInterval(TimeInterval(self.maxTimeDifferenceInHours*60*60))
        tapView.isUserInteractionEnabled = true
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, HH:mm"
        
        if self.selectedFirstCell {
            self.earlierLeave = dateFormatter.string(from: datePicker.date)
            self.earlierDate = datePicker.date
        } else {
            self.latestLeave = dateFormatter.string(from: datePicker.date)
            self.latestDate = datePicker.date
        }
        self.journeyTimeTableView.reloadData()
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        self.datePicker.isHidden = true
        self.tapView.isUserInteractionEnabled = false
    }
    
}


// MARK: Defining Map functions
extension FullRouteViewController: MKMapViewDelegate {
    
    // Renders Map overlays
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if (overlay is MKCircle) {
            let circleRender = MKCircleRenderer(overlay: overlay)
            circleRender.fillColor = UIColor(hue: 9/360, saturation: 66/100, brightness: 92/100, alpha: 0.5)
            circleRender.lineWidth = 10
            
            return circleRender
        }
        return MKPolylineRenderer()
    }
    
    @IBAction func confirmButton(_ sender: Any) {
        
        //criar Journey no CoreData
        newJourney = Journey()
        
        //set attributes for newJorney
        //date from datepicker
        newJourney!.initialHour = self.earlierDate
        newJourney!.finalHour = self.latestDate
        newJourney!.journeyId = UUID()
        
        UserServices.getAuthenticatedUser({ (error, user) in
            if(error == nil && user != nil) {
                self.newJourney!.ownerId = user!.userId
                if(self.newPath != nil) {
                    
               //criar metodo no services para salvar path antes de criar journey
               self.newPath?.managedObjectContext?.insert(self.newJourney!)
                do {
                try self.newPath?.managedObjectContext?.save()
                } catch {
                    print("Ooops \(error)")
                }
                self.newJourney!.has_path = self.newPath!
                    JourneyServices.createJourney(journey: self.newJourney!, { (error) in
                        if (error != nil) {
                            
                        }
                    })
                }
            }
        })
        
        
        //checkMatch
    }
    
    
    
    // Adds map annotations for start and destination of the route
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

extension FullRouteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "journeyTimeCell") as! JourneyTimeTableViewCell
        cell.selectionStyle = .none
        cell.boxView.backgroundColor = UIColor.white

        switch indexPath.row {
        case 0:
            cell.leftLabel.text = "Posso sair a partir de"
            cell.rightLabel.text = self.earlierLeave
        default:
            cell.leftLabel.text = "Preciso sair até"
            cell.rightLabel.text = self.latestLeave
        }
        return cell
    }
}

extension FullRouteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedFirstCell =  indexPath.row == 0 ? true : false
        datePickerConfig()
        let cell = tableView.cellForRow(at: indexPath) as! JourneyTimeTableViewCell
        cell.boxView.backgroundColor = UIColor.red
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! JourneyTimeTableViewCell
        cell.boxView.backgroundColor = UIColor.white
    }
    
}
