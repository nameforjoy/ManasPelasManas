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
        
        setUpContactButton()
        
        UserServices.findById(objectID: self.companionID!) { (error, user) in
            if(error == nil && user != nil)  {
                DispatchQueue.main.async {
                    self.nameLabel.text = user!.name! + ", 22"
                    self.bioLabel.text = user!.bio
                    self.profilePhoto.image = UIImage(named: user!.photo!)
                }
            }
        }
    }
    
    @IBAction func contactButton(_ sender: Any) {
        let whatsappURL = URL(string: "https://api.whatsapp.com/send?phone=05535991341301&text=Vamos+juntas?")
        let appStoreWhatsappURL = URL(string: "https://apps.apple.com/us/app/whatsapp-messenger/id310633997")
        
        if UIApplication.shared.canOpenURL(whatsappURL!) {
            UIApplication.shared.open(whatsappURL!, completionHandler: { (sucess) in
            })
        } else {
            UIApplication.shared.open(appStoreWhatsappURL!, completionHandler: { (sucess) in
            })
        }
    }
    
    fileprivate func setUpContactButton()  {
        self.contactButton.layer.cornerRadius = self.contactButton.frame.height / 4
        let  localizedTitleString = NSLocalizedString("Contact companion", comment: "Label for button which redirects you to a Whatsapp chat with the potential companion whose profile is shown in the screen")
        self.contactButton.setTitle(localizedTitleString, for: .normal)
    }
    
}
