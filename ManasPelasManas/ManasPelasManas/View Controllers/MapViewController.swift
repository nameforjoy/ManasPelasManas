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

// MARK: HandleMapSearch protocol
// Delegate the interaction between the MapViewController and the search adress table
protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

// MARK: MapViewController
class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var radiusView: UIImageView!
    
    let locationManager = CLLocationManager()
    var resultSearchController: UISearchController? = nil
    var selectedPin: MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets up CoreLocation and centers map
        locationManager.delegate = self
        centerMapOnUserLocation()
        
        //SEARCH BAR E TABLEVIEW SETUP
        
        //trazendo a tableViewController do storyboard pro código
        //por isso foi importante ter um storyboard ID na tableViewController
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        //definindo a view de resultados como a tableViewController
        self.resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        //definindo a tableViewController também como updater
        self.resultSearchController?.searchResultsUpdater = locationSearchTable
        
        //criando a searchBar, definindo tamanho, texto exibido e encaixando ela na navigationBar
        let searchBar = self.resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder =  "Entre com seu endereço..."
        navigationItem.titleView =  self.resultSearchController?.searchBar
        
        //comportamento visual da searchcontroller
        //evitar que a navbar suma durante a apresentação da tableViewController, queremos ela o tempo todo
        self.resultSearchController?.hidesNavigationBarDuringPresentation = false
        //transparencia bonitinha
        self.resultSearchController?.dimsBackgroundDuringPresentation = true
        //não deixar a tableViewController tomar conta da VC inteira (se não esconderia a navbar/searchbar sumisse de qualquer jeito
        definesPresentationContext = true
    
        //associando a mapView da searchController sendo a mesma daqui
        // pra que? pra busca ficar preferencial às proximidades
        locationSearchTable.mapView = mapView
        
        //DELEGATE MANUAL
        locationSearchTable.handleMapSearchDelegate = self
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
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region =  MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    // Centers map on user current location
    func centerMapOnUserLocation() {
        locationManager.requestLocation()
        if let location = locationManager.location {
            zoomMapTo(location: location)
        } else {
            presentAlert()
        }
    }
    
    // Shows error message
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    // Hamdles changes in authorization status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            self.activateLocationServices()
        } else if status == .denied || status == .restricted {
            self.presentAlert()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
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
        
        // limpar mapa --> se a gente for fazer o ponto de destino junto, não vai rolar
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality, let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
