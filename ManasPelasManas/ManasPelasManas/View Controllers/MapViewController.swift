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
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet var vcView: UIView!
    
    
    let locationManager = CLLocationManager()
    let maxSpan = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
    let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    
    var resultSearchController: UISearchController? = nil
    var selectedPin: MKPlacemark? = nil
    var locationReference: CLLocation? = nil // Future recentre button
    
    //Setting Up Different Behaviors for Origin and Destination Screens
    var firstTime: Bool = true
    
    //var newPath: PathTest = PathTest()
    var newPath: Path?
    var pathId: UUID?
    
    // MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpInterface()
        adjustText()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets up CoreLocation and centers map
        self.locationManager.delegate = self
        self.checkAuthorizationStatus()

        // Handle Notifications for Category Size Changes

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(fontSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)
        
        // MARK: Adress Search configuration
        
        // CREATES SEARCH CONTROLLER AN m D INSTANTIATES A TABLEVIEWCONTROLLER TO HANDLE THE RESULTS
        // Instantiates the TableViewController that will show the adress results
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTableViewController
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
        searchBar.placeholder =  "Busque por seu endereço"
        self.navigationItem.searchController =  self.resultSearchController!
        
        // PREVENTS THE TABLEVIEW FROM VANISHING WITH OTHER ELEMENTS
        // Prevents the NavigationBar from being  hidden when  showing the TableView
        self.resultSearchController?.hidesNavigationBarDuringPresentation = false
        // Sets recults table background transparency
        self.resultSearchController?.obscuresBackgroundDuringPresentation = false
        // Makes this ViewController the presentation context for the results table, preventing it from overlapping the searchBar
        self.definesPresentationContext = true
        
        // Sets delegate to handle map search with the HandleMapSearch protocol
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.centerMapOnUserLocation()
        
        //VoiceOver setups
        setupAccessibility()
    }

    deinit {

        let notificationCenter = NotificationCenter.default

        notificationCenter.removeObserver(self, name:  UIContentSizeCategory.didChangeNotification, object: nil)
    }

    
    // MARK: Acessibility setup
    private func setupAccessibility() {
        // Disable map interaction with voiceOver
        if UIAccessibility.isVoiceOverRunning {
            self.mapView.accessibilityElementsHidden = true
        }
        
        //1. Botão voltar
        self.navigationController?.navigationBar.backItem?.isAccessibilityElement = true
        // TODO: PROBLEMA - acessibility label do not
        self.navigationController?.navigationBar.backItem?.title = "Voltar. Botão. Toque duplo para voltar à tela do ponto de chegada e descartar o horário de partida."

        //2. Escolha da localização
//        self.resultSearchController!.searchBar.isAccessibilityElement = true
//        self.resultSearchController!.searchBar.accessibilityLabel = "Local de partida: \(self.resultSearchController!.searchBar.placeholder!). Toque duplo para editar local de partida."
        
        //3. Botão de cancelar

        //4. Raio
        // Por enquanto vou usar a label do raio - mas depois mudar para o slider
        self.radiusLabel.isAccessibilityElement = true
        self.radiusLabel.accessibilityLabel = "Raio de deslocamento: \(self.radiusLabel.text!). Arraste o slider para os lados para aumentar ou diminuir o raio."
        
    }
    
    
    // MARK: Actions

    @objc func fontSizeChanged(_ notification: Notification) {
        adjustText()
    }

    func adjustText() {
        if traitCollection.preferredContentSizeCategory.isAccessibilityCategory {
            if self.firstTime {
                self.navigationItem.title = "De onde?"
            } else {
                self.navigationItem.title = "Para onde?"
            }
        } else {
            if self.firstTime {
                self.navigationItem.title = "De onde saímos?"
            } else {
                self.navigationItem.title = "Para onde vamos?"
            }
        }
    }
    
    @IBAction func nextButton(_ sender: Any) {
        
        if firstTime {
            newPath = Path()
            self.newPath?.pathId = UUID()
            self.pathId = newPath?.pathId
            
            let firstArea = self.getCurrentCircularRegion()
            self.newPath?.originLat = firstArea.coordinate.latitude as Double
            self.newPath?.originLong = firstArea.coordinate.longitude as Double
            self.newPath?.originRadius = firstArea.radius as Double
            
            performSegue(withIdentifier: "goToDestination", sender: sender)
        }
        else {
            let secondArea = self.getCurrentCircularRegion()
            self.newPath?.destinyLat = secondArea.coordinate.latitude as Double
            self.newPath?.destinyLong = secondArea.coordinate.longitude as Double
            self.newPath?.destinyRadius = secondArea.radius as Double
            
            //Create path coredata
            PathServices.createPath(path: self.newPath!) { error in
                if (error != nil) {
                    //treat error
                }
            }
            performSegue(withIdentifier: "TimeSetup", sender: sender)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "TimeSetup" {
            if let destination = segue.destination as? FullRouteViewController {
                destination.pathId = self.newPath?.pathId
            }
        }
        else if segue.identifier == "goToDestination" {
            if let destination = segue.destination as? MapViewController {
                destination.firstTime = false
                destination.newPath = self.newPath
            }
        }
    }
    
    // Changes Navigation title depending on which stage of the journey we are currently registering
    private func setUpNavigationTitle() {
        // This function is called in viewDidAppear since viewDidLoad only loads once (when the class is called the first time)
        if self.firstTime {
            self.navigationItem.title = NSLocalizedString("Meeting location", comment: "Navigation title of the screen where the user sets the region where she can meet her companion to start her journey. This region is determined by a circle in the map, of which the user sets its center and radius.")
        } else {
            self.navigationItem.title = NSLocalizedString("Destination location", comment: "Navigation title of the screen where the user sets the final destination of her journey. This region is determined by a circle in the map, of which the user sets its center and radius.")
        }
    }
    
    private func setUpInterface() {
        setUpNavigationTitle()
        
        let nextButtonTitle = NSLocalizedString("Map next button title", comment: "Main button on the map screen to define the journey, that takes the user to the next screen in the process of defining her journey.")
        self.nextButton.setTitle(nextButtonTitle, for: .normal)
        self.nextButton.layer.cornerRadius = self.nextButton.frame.height / 4
    }
    
}

// MARK: CLLocationManager extension
// Handles user authorization and location functions
extension MapViewController: CLLocationManagerDelegate {
    
    // Handles location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.locationReference = location
        }
        self.locationManager.stopUpdatingLocation()
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
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            centerMapOnUserLocation()
        }
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
        let region = MKCoordinateRegion(center: placemark.coordinate, span: self.defaultSpan)
        mapView.setRegion(region, animated: true)
    }
}

// MARK: MapViewDelegate Extension
extension MapViewController: MKMapViewDelegate {
    
    // This function is called everytime map region is changed by user interaction
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        var radius = self.getCurrentCircularRegion().radius
        if radius >= 1000 {
            radius = Double(round(10 * radius) / 1000)
            radiusLabel.text = "\(Int(radius))km"
        } else {
            radiusLabel.text = "\(Int(radius))m"
        }
        
        // Does not allow a bigger region span than the value allowed
        if animated == false {
            if self.mapView.region.span.latitudeDelta > self.maxSpan.latitudeDelta || mapView.region.span.longitudeDelta > self.maxSpan.longitudeDelta {
                let region =  MKCoordinateRegion(center: mapView.region.center, span: self.maxSpan)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    // MARK: Defining Radius
    func getCurrentCircularRegion() -> MKCircle {
        
        let edge2D: CLLocationCoordinate2D = mapView.convert(CGPoint(x: 0, y: self.radiusView.frame.height / 2), toCoordinateFrom: self.radiusView)
        let center2D: CLLocationCoordinate2D = mapView.convert(CGPoint(x: self.radiusView.frame.width / 2 , y: self.radiusView.frame.height / 2), toCoordinateFrom: self.radiusView)
        
        let edge = CLLocation(latitude: edge2D.latitude, longitude: edge2D.longitude)
        let center = CLLocation(latitude: center2D.latitude, longitude: center2D.longitude)
        
        let distance: Double = center.distance(from: edge)
        return MKCircle(center: center.coordinate, radius: distance)
    }
}
