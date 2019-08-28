//
//  RoutesViewController.swift
//  ManasPelasManas
//
//  Created by Beatriz Viseu Linhares on 21/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import UIKit

class RoutesViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var routesTableView: UITableView!
    
    let routesDataSource = RoutesVCTableDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.routesTableView.delegate = self
        self.routesTableView.dataSource = self.routesDataSource
    }
    
    @IBAction func test(_ sender: Any) {

        let data = LoadData()
        let test = Test()

        let users = [data.user1, data.user2, data.user3, data.user4]
        let _ = test.searchForMatch(journey: data.user1.journeys[1], users: users)
    }
}
