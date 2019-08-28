//
//  InfoViewController.swift
//  ManasPelasManas
//
//  Created by Beatriz Viseu Linhares on 21/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import UIKit
import CoreData

class InfoViewController: UIViewController {
    
    var myUser: User?
    fileprivate var journeys: [Journey] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Teste para findUserById
        // Do any additional setup after loading the view.
        
        //        0x855055ae01959adb <x-coredata://FA8F41D4-52C0-484E-8ADD-04578F942271/User/p1>"
        //
//        let userId = UUID(uuidString: "BD35EEAD-3179-4FC2-AC34-5ED619C4EE1F")
//        UserServices.findById(objectID: userId! ) { (error, user) in
//            if (error == nil && user != nil) {
//                //self.displayData(user: user!)
//                print(user?.name)
//            } else if user == nil {
//                print(error)
//
//            }
//        }
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // call super
        super.viewWillAppear(animated)
        
        // get all seasons
        JourneyServices.getAllJourneys { (error, journeys) in
            if (error == nil) {
                // assign season list
                self.journeys = journeys!
                
                // reload table view with season information
                DispatchQueue.main.async {
                    //self.table.reloadData()
                }
            }
            else {
                // display error here because it was not possible to load season list
                print("Error retrieving content")
            }
        }
        
    }



}
