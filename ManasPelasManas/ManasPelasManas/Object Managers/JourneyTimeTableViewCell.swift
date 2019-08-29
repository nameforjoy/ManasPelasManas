//
//  JourneyTimeTableViewCell.swift
//  ManasPelasManas
//
//  Created by Joyce Simão Clímaco on 28/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import Foundation
import UIKit

class JourneyTimeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var boxView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.boxView.layer.cornerRadius = self.boxView.frame.height / 4
        // self.boxView.layer.borderWidth = 1
        // self.boxView.layer.borderColor = UIColor(red:200/255, green:200/255, blue:200/255, alpha: 1).cgColor
    }
}
