//
//  CreateJourneyViewController.swift
//  ManasPelasManas
//
//  Created by Joyce Simão Clímaco on 27/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import Foundation
import UIKit

class CreateJourneyViewController: UIViewController {
    
    @IBOutlet weak var startJourneyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startJourneyButton.layer.cornerRadius = self.startJourneyButton.frame.height / 4
    }
}
