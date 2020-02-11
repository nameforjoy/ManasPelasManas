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
    @IBOutlet weak var nameContentLabel: UILabel!
    @IBOutlet weak var aboutMeTitleLabel: UILabel!
    @IBOutlet weak var aboutMeContentLabel: UILabel!
    @IBOutlet weak var contactButton: UIButton!
    
    var companionID: UUID? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contactButton.layer.cornerRadius = self.contactButton.frame.height / 4
        
        UserServices.findById(objectID: self.companionID!) { (error, user) in
            if(error == nil && user != nil)  {
                DispatchQueue.main.async {
                    self.nameContentLabel.text = user!.name! + ", 22"
                    self.aboutMeContentLabel.text = user!.bio
                    self.profilePhoto.image = UIImage(named: user!.photo!)
                    self.setUpInterface(name: user!.name!)
                }
            }
        }
    }
    
    private func setUpInterface(name: String) {
        
        let contactButtonName = NSLocalizedString("Contact companion", comment: "Button next to possible companion profile. When clicked, it takes you to Whatsapp with a pre-written message in a conversation with the selected companion asking her to join you in this journey")
        self.contactButton.setTitle(contactButtonName, for: .normal)
        
        let aboutCompanionTitle = NSLocalizedString("Companion description", comment: "Title of section in companion profile in which she writes a brief description of herself")
        self.aboutMeTitleLabel.text = String.localizedStringWithFormat(aboutCompanionTitle, name)
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
    
}
