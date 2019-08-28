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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //        0x855055ae01959adb <x-coredata://FA8F41D4-52C0-484E-8ADD-04578F942271/User/p1>"
        //
        let userId = UUID(uuidString: "02C69391-4BD7-4590-AF66-63BEFEAB412D")
        UserServices.findById(objectID: userId! ) { (error, user) in
            if (error == nil && user != nil) {
                //self.displayData(user: user!)
                print(user?.name)
            } else if user == nil {
                print(error)
                print("oi")
                //self.createFakeUser()
                //self.displayData(user: self.currentUser!)
            }
        }
    }



}
