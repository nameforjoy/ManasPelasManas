//
//  MapViewController.swift
//  ManasPelasManas
//
//  Created by Beatriz Viseu Linhares on 21/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// MARK: MapViewController
class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var radiusView: UIImageView!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    
    let locationManager = CLLocationManager()
    let mapRegionDegreeRange: Double = 0.02
    var resultSearchController: UISearchController? = nil
    var selectedPin: MKPlacemark? = nil
    
    //Setting Up Different Behaviors for Origin and Destination Screens
    var firstTime: Bool = true
    //var originCircle: CLCircularRegion?
    //var destinationCircle: CLCircularRegion?
    var newPath: Path = Path()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets up CoreLocation and centers map
        locationManager.delegate = self
        checkAuthorizationStatus()
        centerMapOnUserLocation()
        
        // MARK: Adress Search configuration
        
        // CREATES SEARCH CONTROLLER AN m D INSTANTIATES A TABLEVIEWCONTROLLER TO HANDLE THE RESULTS
        // Instantiates the TableViewController that will show the adress results
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        // Instantiates our search controller and displays its results on the TableView instantiated above
        self.resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        // Sets the TableView as the results updater as well
        self.resultSearchController?.searchResultsUpdater = locationSearchTable
        // Sets this ViewController mapView as the results table mapView
        locationSearchTable.mapView = mapView
        
        // CREATES AND CONFIGURES THE SEARCHBAR
        // Make  searchBar from the searchController created above
        let searchBar = self.resultSearchController!.searchBar
        // Defines searchBar appearence
        searchBar.sizeToFit()
        searchBar.placeholder =  "Entre com seu endereço..."
        self.navigationItem.searchController =  self.resultSearchController!
        //self.view.addSubview(searchBar)
        
        // PREVENTS THE TABLEVIEW FROM VANISHING WITH OTHER ELEMENTS
        // Prevents the NavigationBar from being  hidden when  showing the TableView
        self.resultSearchController?.hidesNavigationBarDuringPresentation = false
        // Sets recults table background transparency
        self.resultSearchController?.dimsBackgroundDuringPresentation = true
        // Makes this ViewController the presentation context for the results table, preventing it from overlapping the searchBar
        self.definesPresentationContext = true
        
        // Sets delegate to handle map search with the HandleMapSearch protocol
        locationSearchTable.handleMapSearchDelegate = self
        
        leftBarButton.isEnabled = false
    }
    
    // MARK: Actions
    
    @IBAction func nextButton(_ sender: Any) {
        if firstTime {
            
            let firstArea = getCurrentCircularRegion()
            newPath.originLat = firstArea.coordinate.latitude as NSNumber
            newPath.originLong = firstArea.coordinate.longitude as NSNumber
            newPath.originRadius = firstArea.radius as NSNumber
    
            navigationItem.title = "Chegada"
            firstTime = !firstTime
            leftBarButton.isEnabled = true
        
        } else
        {
            let secondArea = getCurrentCircularRegion()
            newPath.destinyLat = secondArea.coordinate.latitude as NSNumber
            newPath.destinyLong = secondArea.coordinate.longitude as NSNumber
            newPath.destinyRadius = secondArea.radius as NSNumber
            
            performSegue(withIdentifier: "TimeSetup", sender: sender)
        }
    }
    @IBAction func backButton(_ sender: Any) {
        firstTime = true
        leftBarButton.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TimeSetup" {
            if let vc = segue.destination as? FullRouteViewController {
                vc.newPath = self.newPath
            }
        }
    }
    
    
}

// MARK: CLLocationManager extension
// Handles user authorization and location functions
extension MapViewController: CLLocationManagerDelegate {
    
    // Handles location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            zoomMapTo(location: location)
        }
    }
    
    // Zooms in to a certain map region
    func zoomMapTo(location: CLLocation) {
        let span = MKCoordinateSpan(latitudeDelta: self.mapRegionDegreeRange, longitudeDelta: self.mapRegionDegreeRange)
        let region =  MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    // Centers map on user current location
    func centerMapOnUserLocation() {
        locationManager.requestLocation()
        if let location = locationManager.location {
            zoomMapTo(location: location)
        }
    }
    
    // Shows error message
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    // Checks if Location Services are enabled and if not asks for authorization
    func checkAuthorizationStatus() {
        if CLLocationManager.locationServicesEnabled() {
            let status  = CLLocationManager.authorizationStatus()
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                self.activateLocationServices()
            } else if status == .denied || status == .restricted {
                self.presentAlert()
            } else {
                self.locationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
    // Hamdles changes in authorization status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorizationStatus()
    }
    
    // Starts location services
    func activateLocationServices() {
        // We need a high accuracy since our user is by foot, but  not too  much so that too much battery is consumed
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    // Presents alert if location is turned off
    func presentAlert() {
        let alertController = UIAlertController (title: "Localização", message: "Seus serviços de localização encontram-se desativados para esse app. Utilizamos  esse serviço para facilitar sua definição  de rota, porém o app pode ser utilizado sem ele normalmente. Caso deseje habilitar sua localização nesse app, basta ligar  esse serviço em suas Configurações.", preferredStyle: .alert)
        
        // Adds settings button action
        let settingsAction = UIAlertAction(title: "Configurações", style: .default) { (_) -> Void in
            
            // Gets the URL for this app's Settings
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            // Opens URL when clicking the button
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (sucess) in
                    print("Settings opened: \(sucess)") // Prints true
                })
            }
        }
        // Adds Cancel button action
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        // Presents Alert
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: HandleMapSearch extension
// Instantiates the protocol at the beginning of this ducoment to pass address search information
extension MapViewController: HandleMapSearch {
    
    func dropPinZoomIn(placemark: MKPlacemark) {
        selectedPin = placemark
        // Removes all previous annotations
        mapView.removeAnnotations(mapView.annotations)
        
        // Adds annotation in the  given placemark
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality, let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        
        // Shows corresponding map region
        let span = MKCoordinateSpan(latitudeDelta: self.mapRegionDegreeRange, longitudeDelta: self.mapRegionDegreeRange)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}

// MARK: MapViewDelegate Extension
extension MapViewController: MKMapViewDelegate {
    
    // This function is called everytime map region is changed by user interaction
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        radiusLabel.text = "Raio: \(Int(self.getCurrentCircularRegion().radius)) metros"
    }
    
    // MARK: Defining Radius
    func getCurrentCircularRegion() -> MKCircle
    {
        let edge2D: CLLocationCoordinate2D = mapView.convert(CGPoint(x: 0, y: self.radiusView.frame.height / 2), toCoordinateFrom: self.radiusView)
        let center2D: CLLocationCoordinate2D = mapView.convert(CGPoint(x: self.radiusView.frame.width / 2 , y: self.radiusView.frame.height / 2), toCoordinateFrom: self.radiusView)
        
        let edge = CLLocation(latitude: edge2D.latitude, longitude: edge2D.longitude)
        let center = CLLocation(latitude: center2D.latitude, longitude: center2D.longitude)
        
        let distance: Double = center.distance(from: edge)
        //print("Radius is \(distance)m")
        //radiusLabel.text = "Raio: \(distance) metros"
        
        return MKCircle(center: center.coordinate, radius: distance)
    }
}
