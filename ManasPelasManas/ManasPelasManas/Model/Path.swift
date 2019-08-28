//
//  Path.swift
//  ManasPelasManas
//
//  Created by Luma Gabino Vasconcelos on 22/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import Foundation
import MapKit

class Path {
    var pathId: Int?
    var origin: MKCircle?
    var destiny: MKCircle?
    
    init () {
    }
    
    init (pathId: Int, origin: MKCircle, destiny: MKCircle) {
        self.pathId = pathId
        self.origin = origin
        self.destiny = destiny
    }
    
    
}
