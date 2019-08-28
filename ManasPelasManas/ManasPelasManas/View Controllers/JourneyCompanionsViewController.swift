//
//  JourneyCompanionsViewController.swift
//  ManasPelasManas
//
//  Created by Joyce Simão Clímaco on 28/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import Foundation
import UIKit

class JourneyCompanionsViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeRangeLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var companionsTableView: UITableView!
    
    let companionsDataSource = CompanionsDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.companionsTableView.delegate = self
        self.companionsTableView.dataSource = self.companionsDataSource
    }
}
