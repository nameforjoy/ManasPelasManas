//
//  FullJourneyDetailsCell.swift
//  ManasPelasManas
//
//  Created by Joyce Simão Clímaco on 28/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import Foundation
import UIKit

class FullJourneyDetailsCell: UITableViewCell {
    
    @IBOutlet weak var contourView: UIView!
    @IBOutlet weak var notificationView: UIView!
    
    @IBOutlet weak var dateTitle: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var arrivalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.departureLabel.text = NSLocalizedString("Departure cell on tableView", comment: "Address of departure from journey")
        self.arrivalLabel.text = NSLocalizedString("Arrival address on tableView", comment: "Address of arrival from journey")
        
        self.contourView.layer.borderWidth = 1
        // self.contourView.backgroundColor = UIColor(named: "backgroundColor")
        self.contourView.layer.cornerRadius = self.contourView.frame.height / 10
        self.contourView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        
        // Rounding photos and notification view
        self.notificationView.layer.cornerRadius = self.notificationView.frame.height / 2
    }
}

