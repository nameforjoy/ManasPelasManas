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
    @IBOutlet weak var aboutMeTitleLabel: UILabel!
    
    @objc var currentUser: User?
    @objc var authenticatedUser: User?
    @objc var journeyTest: Journey?
    @objc var pathTest: Path?
    @objc var journeyMock: Journey?
    @objc var pathMock: Path?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserServices.getAuthenticatedUser { (error, user) in
            if (error == nil && user != nil) {
                self.displayData(user: user!)
            } else if user == nil {
                //tratar errro
            }
        }
    }
    
    private func displayData(user: User) {
        self.profilePhoto.image = UIImage(named: (user.photo)!)
        self.nameContentLabel.text = (user.name)! + ", 19"
        self.aboutMeContentLabel.text = (user.bio)!
    }
    
    
}

