//
//  CompanionProfileViewController.swift
//  ManasPelasManas
//
//  Created by Joyce Simão Clímaco on 28/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import Foundation
import UIKit

class CompanionProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioTitleLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var contactButton: UIButton!
    
    var companionID: UUID? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contactButton.layer.cornerRadius = self.contactButton.frame.height / 4
        
        UserServices.findById(objectID: self.companionID!) { (error, user) in
            if(error == nil && user != nil)  {
                DispatchQueue.main.async {
                    self.nameLabel.text = user!.name
                    self.bioLabel.text = user!.bio
                    self.profilePhoto.image = UIImage(named: user!.photo!)
                }
            }
        }
    }
    
}
