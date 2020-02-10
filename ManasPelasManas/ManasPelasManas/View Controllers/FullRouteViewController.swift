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
    
    var currentUser: User?
    var newPath: Path?
    var newJourney: Journey?
    var pathId: UUID?
    
    var annotationA: MKPointAnnotation?
    var annotationB: MKPointAnnotation?
    var earlierDate: Date? = nil
    var latestDate: Date? = nil
    var selectedFirstCell: Bool = true
    let maxTimeDifferenceInHours: Double = 8
    var circleA: MKCircle?
    var circleB: MKCircle?
    
    //@IBOutlet weak var journeyTimeTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var fromDateStackView: UIStackView!
    @IBOutlet weak var toDateStackView: UIStackView!
    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var toDateLabel: UILabel!
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var toDateTextField: UITextField!
    var activeField: UITextField?

    override func viewDidLoad() {

        datePickerConfig()
        textFieldConfig()

        self.fromDateLabel.text = NSLocalizedString("Earliest meeting time", comment: "Title of the table cell in which the user clicks to set up the earlier boundary of the time range in which she can encounter her companion for this journey.")
        self.toDateLabel.text = NSLocalizedString("Latest meeting time", comment: "Title of the table cell in which the user clicks to set up the latest boundary of the time range in which she can encounter her companion for this journey.")

        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(fontSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }

    // Stop observing notifications once class is removed
    deinit {
        let nc = NotificationCenter.default

        nc.removeObserver(self, name:  UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpInterface()

        
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
    
    private func setUpInterface() {
        adjustTextContent()
        self.nextButton.layer.cornerRadius = self.nextButton.frame.height / 4
    }

    // MARK: Dynamic Type
    // Listens to changes on Category Size Changes
    @objc func fontSizeChanged(_ notification: Notification) {
        adjustTextContent()
    }

    // Changes text content depending on accessibility status
    func adjustTextContent() {
        let shortTitle = NSLocalizedString("Short Time of journey", comment: "Navigation title of the screen in which the user inputs the time range in which she can start the journey.")
        let longTitle = NSLocalizedString("Long Time of journey", comment: "Navigation title of the screen in which the user inputs the time range in which she can start the journey.")
        let shortSearchForCompanionsButtonTitle = NSLocalizedString("Short Finish creating journey button", comment: "Button localized in the last screen in which the user inputs information to create a journey. Upon pressing this button, her journey will be officially created and the app will automatically search for companions for her.")
        let longSearchForCompanionsButtonTitle = NSLocalizedString("Long Finish creating journey button", comment: "Button localized in the last screen in which the user inputs information to create a journey. Upon pressing this button, her journey will be officially created and the app will automatically search for companions for her.")

        if traitCollection.preferredContentSizeCategory.isAccessibilityCategory {
            self.navigationItem.title = shortTitle
            self.nextButton.setTitle(shortSearchForCompanionsButtonTitle, for: .normal)
        } else {
            self.navigationItem.title = longTitle
            self.nextButton.setTitle(longSearchForCompanionsButtonTitle, for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //VoiceOver setups
        setupAccessibility()
    }
    
    // MARK: Acessibility setup
    private func setupAccessibility() {
        // Disable map interaction with voiceOver
        //Habilitar apenas quando a tapView tiver na mesma reagião da mapView
        if UIAccessibility.isVoiceOverRunning {
            self.mapView.accessibilityElementsHidden = true
        }
        
        //1. Botão voltar
        self.navigationController?.navigationBar.backItem?.isAccessibilityElement = true
        // TODO: PROBLEMA - acessibilityLabel do not change the voiceOver reading
        self.navigationController?.navigationBar.backItem?.title = "Voltar. Botão. Toque duplo para voltar à tela do ponto de chegada e descartar o horário de partida."
        
        //6. Botão procurar companhias
        self.nextButton.isAccessibilityElement = true
        self.nextButton.accessibilityLabel = "Procurar companhias. Botão."

    }
        
    
    // MARK: Displaying Map Data
    func displayMapItems(path: Path?) {
        let pathServices = PathServices()
        
        if let path = path {
            self.circleA = pathServices.getCircle(path: path, stage: .origin)
            self.circleB = pathServices.getCircle(path: path, stage: .destiny)
        } else {
            print("Path is null")
        }
        
        self.addAnnotations()
        
        self.mapView.addAnnotations([annotationA!, annotationB!])
        self.mapView.addOverlays([self.circleA!, self.circleB!])
        
        self.zoomTo(regionA: self.circleA!, regionB: self.circleB!)
    }
    
    func presentAlert() {
        let alertController = UIAlertController (title: "Horário de saída", message: "Defina o intervalo de tempo em que você deseja iniciar seu trajeto para continuar", preferredStyle: .alert)
        
        // Adds Cancel button action
        let cancelAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        // Presents Alert
        present(alertController, animated: true, completion: nil)
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
        
        if self.earlierDate != nil && self.latestDate != nil {
            
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
                        //self.newPath?.managedObjectContext?.insert(self.newJourney!)
                        
                        do {
                            self.newJourney!.has_path = self.newPath!
                            JourneyServices.createJourney(journey: self.newJourney!, { (error) in
                                
                                if (error == nil) {
                                    DispatchQueue.main.async {
                                        self.performSegue(withIdentifier: "checkForMatches", sender: sender)
                                    }
                                } else {
                                    print(error?.localizedDescription ?? "Error")
                                }
                            })
                        } catch {
                            print("Error: \(error)")
                        }
                    }
                }
            })
            
        } else {
            presentAlert()
        }
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
    
    // TODO: Zoom to fit all elements
    private func zoomTo(regionA: MKCircle, regionB: MKCircle) {
        let boundingArea = (regionA.boundingMapRect).union(regionB.boundingMapRect)
        let padding = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        mapView.visibleMapRect = mapView.mapRectThatFits(boundingArea, edgePadding: padding)
    }
    
}

    // MARK: TextField Setup
extension FullRouteViewController {
    
    // LOCALIZAR ISSO
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm, MMM d"
        return dateFormatter.string(from: date)
    }
    
    func dateToStringAccessible(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "pt_BR")
        
        let dayString = dateFormatter.string(from: date)
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
    
        return "\(hour) horas e \(minute) minutos, " + "de " + dayString
    }
}

// MARK: DatePicker Extension
extension FullRouteViewController {

    @objc func dateChanged(datePicker: UIDatePicker) {
        guard let activeField = self.activeField else { return }

        if activeField.tag == 0 {
            self.earlierDate = datePicker.date
        } else if activeField.tag == 1 {
            self.latestDate = datePicker.date
        }
        activeField.text = dateToString(date: datePicker.date)
    }

    func datePickerConfig() {
        self.datePicker.isHidden = true
        self.datePicker?.datePickerMode = .dateAndTime
        self.datePicker?.backgroundColor = .white
        self.datePicker?.addTarget(self, action: #selector(FullRouteViewController.dateChanged(datePicker: )), for: .valueChanged)

        // Set minimum and maximum date
        self.datePicker.minimumDate = Date()

        // Setting date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, HH:mm"

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

        createDatePicker(forField: fromDateTextField)
        createDatePicker(forField: toDateTextField)
    }

    func createDatePicker(forField field : UITextField){

        //Creates ToolBar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.isUserInteractionEnabled = true

        // Creates Done Button with Flexible Space for Left Alignment
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem:.done, target: self, action: #selector(donePressed))

        // Includes items to the toolbar
        toolbar.setItems([flexButton, done], animated: false)

        // Ties up the toolbar to the datepicker
        field.inputAccessoryView = toolbar
        // Sets the datepicker as the textField input
        field.inputView = datePicker
    }

    // Dismiss datepicker and saves data if necessary
    @objc func donePressed() {
        view.endEditing(true)
    }
}

// MARK: TextField Setup Extension
extension FullRouteViewController: UITextFieldDelegate {

    func textFieldConfig(){
        self.fromDateTextField.delegate = self
        self.toDateTextField.delegate = self
        self.fromDateTextField.tag = 0
        self.toDateTextField.tag = 1
        self.fromDateTextField.text = dateToString(date: Date())
        self.toDateTextField.text = dateToString(date: Date())


        // Removing default design for text field
        self.fromDateTextField.borderStyle = .none
        self.toDateTextField.borderStyle = .none
    }

    // This function is called by the delegate when user taps a given text field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            self.earlierDate = datePicker.date
            self.fromDateLabel.textColor = UIColor(named: "actionColor")
            self.toDateLabel.textColor = .black
        } else if textField.tag == 1 {
            self.latestDate = datePicker.date
            self.fromDateLabel.textColor = .black
            self.toDateLabel.textColor = UIColor(named: "actionColor")
            
        }
        self.activeField = textField
        datePicker.isHidden = false
    }
}
