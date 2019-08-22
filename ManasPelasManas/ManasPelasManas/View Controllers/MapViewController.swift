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

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    var resultSearchController: UISearchController? = nil
    
    var selectedPin: MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.delegate = self
        
        //Corelocation setup
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        if let location = locationManager.location {
            zoomTo(location: location)
        }
        
        //SEARCH BAR E TABLEVIEW SETUP
        
        //trazendo a tableViewController do storyboard pro código
        //por isso foi importante ter um storyboard ID na tableViewController
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        //definindo a view de resultados como a tableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        //definindo a tableViewController também como updater
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        //criando a searchBar, definindo tamanho, texto exibido e encaixando ela na navigationBar
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder =  "Entre com seu endereço..."
        navigationItem.titleView =  resultSearchController?.searchBar
        
        //comportamento visual da searchcontroller
        //evitar que a navbar suma durante a apresentação da tableViewController, queremos ela o tempo todo
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        //transparencia bonitinha
        resultSearchController?.dimsBackgroundDuringPresentation = true
        //não deixar a tableViewController tomar conta da VC inteira (se não esconderia a navbar/searchbar sumisse de qualquer jeito
        definesPresentationContext = true
    
        //associando a mapView da searchController sendo a mesma daqui
        // pra que? pra busca ficar preferencial às proximidades
        locationSearchTable.mapView = mapView
        
        //DELEGATE MANUAL
        locationSearchTable.handleMapSearchDelegate = self
        
    }
    
}



extension MapViewController: MKMapViewDelegate {
    
    //delegate  functions
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //código pra quando a usuária scrollar o mapa
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    //funções do tutorial estavam em um swift antigo
    //lebrar de usar autocomplete em vez de ctrl c ctrl v
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            zoomTo(location: location)
        }
    }
    
    func zoomTo(location: CLLocation)
    {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region =  MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }

}

extension MapViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        selectedPin = placemark
        
        //limpar mapa --> se a gente for fazer o ponto de destino junto, não vai rolar
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
