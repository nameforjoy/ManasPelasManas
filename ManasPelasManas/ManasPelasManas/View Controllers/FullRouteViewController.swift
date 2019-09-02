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
    var earlierDate: Date? = nil
    var latestDate: Date? = nil
    var selectedFirstCell: Bool = true
    let maxTimeDifferenceInHours: Double = 8
    var circleA: MKCircle?
    var circleB: MKCircle?
    
    @IBOutlet weak var journeyTimeTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
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
        self.nextButton.layer.cornerRadius = self.nextButton.frame.height / 4
        
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
        self.datePicker?.datePickerMode = .dateAndTime
        self.datePicker?.backgroundColor = .white
        self.datePicker?.addTarget(self, action: #selector(FullRouteViewController.dateChanged(datePicker: )), for: .valueChanged)
        self.datePicker?.isHidden = false

        // Set minimum and maximum date
        self.datePicker.minimumDate = Date()
        
        // Setting date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, HH:mm"
        tapView.isUserInteractionEnabled = true
        
        self.datePicker.minimumDate = Date() //
        self.datePicker.maximumDate = Date().addingTimeInterval(TimeInterval(60*60*24*60))
        
        // Do not let time range be bigger than self.maxTimeDifferenceInHours for security reasons
        if self.selectedFirstCell  && self.latestDate != nil {
            self.datePicker.maximumDate = self.latestDate
            self.datePicker.minimumDate = self.latestDate?.addingTimeInterval(TimeInterval(-self.maxTimeDifferenceInHours*60*60))
        }
        else if !self.selectedFirstCell && self.earlierDate != nil {
            self.datePicker.minimumDate = self.earlierDate
            self.datePicker.maximumDate = self.earlierDate?.addingTimeInterval(TimeInterval(self.maxTimeDifferenceInHours*60*60))
        }
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        
        if self.selectedFirstCell {
            self.earlierDate = datePicker.date
        } else {
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
                        self.newJourney!.has_path = self.newPath!
                        JourneyServices.createJourney(journey: self.newJourney!, { (error) in
                            if (error == nil) {
                                DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: "checkForMatches", sender: sender)
                                }
                                
                            } else {
                                print(error?.localizedDescription)
                            }
                        })
                    } catch {
                        print("Ooops \(error)")
                    }
                    
                   
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "checkForMatches" {
            if let destination = segue.destination as? JourneyCompanionsViewController {
                destination.journeyId = self.newJourney?.journeyId
            }
        }
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
        // cell.boxView.backgroundColor = UIColor.white

        switch indexPath.row {
        case 0:
            cell.leftLabel.text = "Posso sair a partir de"
            if let time = self.earlierDate {
                cell.rightLabel.text = dateToString(date: time)
            } else {
                cell.rightLabel.text = " "
            }
        default:
            cell.leftLabel.text = "Preciso sair até as"
            if let time = self.latestDate {
                cell.rightLabel.text = dateToString(date: time)
            } else {
                cell.rightLabel.text = " "
            }
        }
        return cell
    }
    
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, HH:mm"
        return dateFormatter.string(from: date)
    }
}

extension FullRouteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedFirstCell =  indexPath.row == 0 ? true : false
        datePickerConfig()
        let cell = tableView.cellForRow(at: indexPath) as! JourneyTimeTableViewCell
        cell.boxView.backgroundColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
        
        let otherCellRowIndex = indexPath.row == 0 ? 1 : 0
        let otherCell = tableView.cellForRow(at: IndexPath(row: otherCellRowIndex, section: indexPath.section)) as! JourneyTimeTableViewCell
        otherCell.boxView.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! JourneyTimeTableViewCell
        cell.boxView.backgroundColor = UIColor.white
    }
    
}
