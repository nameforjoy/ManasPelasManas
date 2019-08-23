//
//  LocationSearchTable.swift
//  ManasPelasManas
//
//  Created by Beatriz Viseu Linhares on 22/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTable: UITableViewController {
    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? =  nil
    var handleMapSearchDelegate:HandleMapSearch? = nil

    //função copiada do tutorial pra parsear o endereço
    //tem algum erro que tá fazendo ficar sem espaço entre cidade-estado
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format: "%@%@%@%@%@%@%@",
            // street name
            selectedItem.thoroughfare ?? "",
            firstSpace,
            // street number
            selectedItem.subThoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
    
}

extension LocationSearchTable: UISearchResultsUpdating {

    // delegando o updater dos resultados para silenciar erro da MapViewController
    //        resultSearchController?.searchResultsUpdater = locationSearchTable
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView, let searchBarText = searchController.searchBar.text else {return}
        
        //talvez usar regex pra pegar só quando tiver um espaço
        
        guard searchBarText.contains(" ") && searchBarText.count > 4 else {return}
        
        //criando request
        let request = MKLocalSearch.Request()
        
        //linkando input da busca como texto que está na searchbar
        request.naturalLanguageQuery = searchBarText
        
        //filtrando resultados para área que o mapa está exibindo
        request.region = mapView.region
        
        //efetuando a busca e colocando resultados na matchingItems
        let search = MKLocalSearch(request: request)
        
        //os requests acontecem de forma assíncrona, e retornam resultados fora de ordem
        //por conta disso, criar uma Queue permitiria que eu cancelasse as requests anteriores
        //quando tivesse uma nova request
        //let opQueue = OperationQueue()
        //opQueue.maxConcurrentOperationCount = 1
        
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
        print(matchingItems[indexPath.row].placemark.description)
        let selectedItem =  matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
}
