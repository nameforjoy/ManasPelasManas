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
    
    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? =  nil
    var handleMapSearchDelegate: HandleMapSearch? = nil

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

extension LocationSearchTable: UISearchResultsUpdating {

    // MARK: Update Search Results
    // This method is called everytime the user changes the input on the SearchBar
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let mapView = mapView, let searchBarText = searchController.searchBar.text else {return}
        
        // Prevents useless requests from being made
        guard searchBarText.contains(" ") && searchBarText.count > 4 else {return}
        
        // Creating Request
        let request = MKLocalSearch.Request()
        
        // Getting input from SearchBar
        request.naturalLanguageQuery = searchBarText
        
        // Prioritizing results close to user's location
        request.region = mapView.region
        
        // Creating a LocalSearch based on the previous request
        let search = MKLocalSearch(request: request)
        
        // Executing Search
        // TODO: Improve request by using Operation Queues
        search.start { (response, _) in
                guard let response = response else {return}
                self.matchingItems = response.mapItems
                self.tableView.reloadData()
        }
    }
}

extension LocationSearchTable {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem =  matchingItems[indexPath.row].placemark
        cell.textLabel?.text =  selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem =  matchingItems[indexPath.row].placemark
        
        // Manual Delegate Function
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        
        dismiss(animated: true, completion: nil)
    }
}
