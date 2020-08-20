//
//  MapViewController+AddressSearch.swift
//  ManasPelasManas
//
//  Created by Joyce Simão Clímaco on 06/02/20.
//  Copyright © 2020 Luma Gabino Vasconcelos. All rights reserved.
//

import Foundation
import MapKit

// Handles Protocol for address search table
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
        // We divide the default distance span per 0.9 since the radius image over the map  occupies 0.9 of its width
        let region = MKCoordinateRegion.init(center: placemark.coordinate, latitudinalMeters: self.defaultRadius/0.9, longitudinalMeters: self.defaultRadius/0.9)
        mapView.setRegion(region, animated: true)
    }
}

extension MapViewController {
    
    func addressSearchConfiguration() {
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
        self.navigationItem.searchController =  self.resultSearchController!
        searchBar.placeholder =  NSLocalizedString("Address search", comment: "Placeholder for address search controller")
        
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
}
