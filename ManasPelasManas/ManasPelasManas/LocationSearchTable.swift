//
//  LocationSearchTable.swift
//  ManasPelasManas
//
//  Created by Beatriz Viseu Linhares on 22/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import UIKit
import MapKit

// MARK: HandleMapSearch protocol
// Delegate the interaction between the MapViewController and the search adress table
protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

class LocationSearchTable: UITableViewController {
    
    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView? =  nil
    var handleMapSearchDelegate: HandleMapSearch? = nil
    var dateLastUpdated: Date = Date()
    
    lazy var adressSearchQeue: OperationQueue = {
        var qeue = OperationQueue()
        qeue.name = "Adress search results qeue"
        qeue.maxConcurrentOperationCount = 1
        return qeue
    } ()

    // MARK: Parsing Address
    // This method was based on US Address and might not be entirely effective for our standards.
    func parseAddress(selectedItem:MKPlacemark) -> String {
        
        // Put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // Put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // Put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        
        let addressLine = String(
            format: "%@%@%@%@%@%@%@",
            // Street name
            selectedItem.thoroughfare ?? "",
            firstSpace,
            // Street number
            selectedItem.subThoroughfare ?? "",
            comma,
            // City
            selectedItem.locality ?? "",
            secondSpace,
            // State
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
}

// MARK: Update Search Results
extension LocationSearchTable: UISearchResultsUpdating {
    
    // This method is called everytime the user changes the input on the SearchBar
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let mapView = mapView, let searchBarText = searchController.searchBar.text else {return}
        
        adressSearchQeue.cancelAllOperations()
        
        adressSearchQuery(searchBarText: searchBarText,
                          mapView: mapView,
                          completion: { (items: [MKMapItem]) -> Void in
            self.matchingItems = items
            self.tableView.reloadData()
        })

    }
    
    // Checks if the minimum time between search updates has passed
    func shouldUpdateAdressSearch() -> Bool {
        
        // In timeIntervalSinceNow, if the date object is earlier than the current date and time, this property’s value is negative
        let shoudUpdate: Bool = self.dateLastUpdated.timeIntervalSinceNow < -1 ? true : false
        
        if shoudUpdate {
            self.dateLastUpdated = Date()
        }
        return shoudUpdate
    }
    
    // Performs the  address search
    func adressSearchQuery(searchBarText: String, mapView: MKMapView, completion: @escaping ([MKMapItem]) -> Void) {
        
        if shouldUpdateAdressSearch() {
            self.adressSearchQeue.addOperation {
                
                // Creating Request
                let request = MKLocalSearch.Request()
                
                // Getting input from SearchBar
                request.naturalLanguageQuery = searchBarText
                
                // Prioritizing results close to user's location
                request.region = mapView.region
                
                // Creating a LocalSearch based on the previous request
                let search = MKLocalSearch(request: request)
                
                // Makes search query
                search.start { (response, error) in
                    guard let response = response else {return}
                    completion(response.mapItems)
                }
            }
        }
    }
    
}

extension LocationSearchTable {
    
    // Number of cells in the TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    // Handles cell format and information
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem =  matchingItems[indexPath.row].placemark
        cell.textLabel?.text =  selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
        return cell
    }
    
    // Handles cell selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem =  matchingItems[indexPath.row].placemark
        
        // Manual Delegate Function
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        
        dismiss(animated: true, completion: nil)
    }
}
