//
//  CompanionCell.swift
//  ManasPelasManas
//
//  Created by Joyce Simão Clímaco on 28/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import Foundation
import UIKit

class CompanionCell: UITableViewCell {
    
    @IBOutlet weak var contourView: UIView!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contourView.layer.borderWidth = 1
        self.contourView.backgroundColor = UIColor.white
        self.contourView.layer.cornerRadius = self.contourView.frame.height / 10
        self.contourView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        
        // Rounding photos and notification view
        self.userPhoto.layer.cornerRadius = self.userPhoto.frame.height / 2
    }
}
