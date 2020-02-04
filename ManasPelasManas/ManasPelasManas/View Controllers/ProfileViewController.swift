//
//  ProfileViewController.swift
//  ManasPelasManas
//
//  Created by Beatriz Viseu Linhares on 21/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var nameContentLabel: UILabel!
    @IBOutlet weak var aboutMeContentLabel: UILabel!
    
    @IBOutlet weak var profileOverviewTitleLabel: UILabel!
    @IBOutlet weak var habitationLabel: UILabel!
    @IBOutlet weak var entranceDateLabel: UILabel!
    @IBOutlet weak var companionsNumberLabel: UILabel!
    
    
    @IBOutlet weak var aboutMeTitleLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    
    var currentUser: User?
    var authenticatedUser: User?
    var journeyTest: Journey?
    var pathTest: Path?
    var journeyMock: Journey?
    var pathMock: Path?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserServices.getAuthenticatedUser { (error, user) in
            if (error == nil && user != nil) {
                self.displayData(user: user!)
                self.setupAccessibility(for: user!)
            } else if user == nil {
                //tratar errro
            }
        }
        
    }
    
    // MARK: - Acessibility
    private func setupAccessibility(for user: User) {
        //1. Nome e Idade
        self.nameContentLabel.isAccessibilityElement = true
        self.nameContentLabel.accessibilityLabel = "Nome, \(user.name!)"
        
        //2. Ocupação
        self.occupationLabel.isAccessibilityElement = true
        self.occupationLabel.accessibilityLabel = "Ocupação, \(occupationLabel.text!)"

        //3. Visão geral
        self.profileOverviewTitleLabel.isAccessibilityElement = true
        self.habitationLabel.isAccessibilityElement = false
        self.entranceDateLabel.isAccessibilityElement = false
        self.companionsNumberLabel.isAccessibilityElement = false
        self.profileOverviewTitleLabel.accessibilityLabel = "Mora em , \(habitationLabel.text!), é \(entranceDateLabel.text!), e tem \(companionsNumberLabel.text!)"
       
        //4. Sobre mim
        self.aboutMeTitleLabel.isAccessibilityElement = true
        self.aboutMeContentLabel.isAccessibilityElement = false
        self.aboutMeTitleLabel.accessibilityLabel = "Sobre mim, \(aboutMeContentLabel.text!)"
        
    }
    
    private func displayData(user: User) {
        self.profilePhoto.image = UIImage(named: (user.photo)!)
        self.nameContentLabel.text = (user.name)! + ", 19"
        self.aboutMeContentLabel.text = (user.bio)!
    }
    
    
}

