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
    
    @IBOutlet weak var radiusImageView: UIImageView!
    @IBOutlet weak var radiusTitleLabel: UILabel!
    @IBOutlet weak var radiusMetersLabel: UILabel!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var radiusLabelAndSliderStackView: UIStackView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet var vcView: UIView!
    
    let maxRadius: Double = 1200 // meters
    let minRadius: Double = 50 // meters
    let defaultRadius: Double = 250 // meters
    let locationManager = CLLocationManager()
    
    var isTouchingSlider: Bool = false
    var resultSearchController: UISearchController? = nil
    var selectedPin: MKPlacemark? = nil
    var locationReference: CLLocation? = nil // Future recentre button
    
    //Setting Up Different Behaviors for Origin and Destination Screens
    var firstTime: Bool = true
    
    // var newPath: PathTest = PathTest()
    var newPath: Path?
    var pathId: UUID?
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpInterface()
        adjustText()
        radiusSlider.value = Float(self.defaultRadius)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        radiusSlider.minimumValue = Float(self.minRadius) // meters
        radiusSlider.maximumValue = Float(self.maxRadius) // meters
        
        // Sets up CoreLocation and centers map
        self.locationManager.delegate = self
        self.checkAuthorizationStatus()

        // Handle Notifications for Category Size Changes
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(fontSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)
        
        // Disables map rotation so that the region adjustment through the slider can happen without having to rotate back to the default orientation every time
        mapView.isRotateEnabled = false
        // Brings map to back
        self.view.sendSubviewToBack(mapView)
        
        // Configures addres search bar and results table view
        addressSearchConfiguration()
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
        // TODO: PROBLEMA - acessibilityLabel do not change the voiceOver reading
        self.navigationController?.navigationBar.backItem?.title = "Voltar. Botão. Toque duplo para voltar à tela do ponto de partida e descartar o local de chegada."

        //2. Escolha da localização
        self.resultSearchController!.searchBar.accessibilityTraits = UIAccessibilityTraits.searchField
        
        if #available(iOS 13.0, *) {
            self.resultSearchController!.searchBar.searchTextField.isAccessibilityElement = true
            self.resultSearchController!.searchBar.searchTextField.accessibilityLabel = "Local de partida. Toque duplo para editar local de partida."
        } else {
            // Fallback on earlier versions
        }
    }
    
    // MARK: Actions
    
    @IBAction func beganTouchingSlider(_ sender: UISlider) {
        self.isTouchingSlider = true
    }
    
    @IBAction func finishedTouchingSlider(_ sender: UISlider) {
        self.isTouchingSlider = false
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentRadius = Double(sender.value)
        self.zoomMapWithSlider(sliderRadius: currentRadius)
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
    
    // MARK: Functions
    
    @objc func fontSizeChanged(_ notification: Notification) {
        adjustText()
    }

    func adjustText() {
        
        self.radiusTitleLabel.text = NSLocalizedString("Radius title", comment: "Title for the radius meters")
        if traitCollection.preferredContentSizeCategory.isAccessibilityCategory {
            
            self.radiusLabelAndSliderStackView.axis = .vertical
            
            if self.firstTime {
                self.navigationItem.title = NSLocalizedString("Meeting location short", comment: "Short version of navigation title of the screen where the user sets the region where she can meet her companion to start her journey. This region is determined by a circle in the map, of which the user sets its center and radius.")
            } else {
                self.navigationItem.title = NSLocalizedString("Destination location short", comment: "Short version of navigation title of the screen where the user sets the final destination of her journey. This region is determined by a circle in the map, of which the user sets its center and radius.")
            }
        } else {
            if self.firstTime {
                self.navigationItem.title = NSLocalizedString("Meeting location long", comment: "Long version of navigation title of the screen where the user sets the region where she can meet her companion to start her journey. This region is determined by a circle in the map, of which the user sets its center and radius.")
            } else {
                self.navigationItem.title = NSLocalizedString("Destination location long", comment: "Long version of navigation title of the screen where the user sets the final destination of her journey. This region is determined by a circle in the map, of which the user sets its center and radius.")
            }
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

    private func setUpInterface() {
        let nextButtonTitle = NSLocalizedString("Map next button title", comment: "Main button on the map screen to define the journey, that takes the user to the next screen in the process of defining her journey.")
        self.nextButton.setTitle(nextButtonTitle, for: .normal)
        self.nextButton.layer.cornerRadius = self.nextButton.frame.height / 4
    }
    
}
