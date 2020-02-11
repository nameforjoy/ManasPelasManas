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
        
        setUpLabels()
        
        UserServices.getAuthenticatedUser { (error, user) in
            if (error == nil && user != nil) {
                self.displayData(user: user!)
                self.setupAccessibility(for: user!)
            } else if user == nil {
                //tratar errro
            }
        }
        
    }
    
    // LOCALIZAR ISSO TAMBÉM
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
    
    // MARK: - Auxiliary functions
    private func displayData(user: User) {
        self.profilePhoto.image = UIImage(named: (user.photo)!)
        self.nameContentLabel.text = (user.name)! + ", 19"
        self.aboutMeContentLabel.text = (user.bio)!
    }
    
    private func setUpLabels() {
        profileOverviewTitleLabel.text = NSLocalizedString("User profile overview", comment: "Label for a section filled with pre-defined user information in the form of topics. This topics are: user current city of residence, month when user first registered to the app, and number of companions the user already had on journeys through this app. Must be in all caps.")
        aboutMeTitleLabel.text = NSLocalizedString("User description", comment: "Titled 'Acout me' in english, this is the title for a section in which the users may write about themselves in their profile. This description will be exibited to users who are doing the same journey as she is, and may influence other women's decision of whether accepting their companionship through the journey or not. Must be in all caps.")
    }
}

