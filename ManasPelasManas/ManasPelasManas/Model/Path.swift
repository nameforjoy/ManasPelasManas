//
//  Path.swift
//  ManasPelasManas
//
//  Created by Luma Gabino Vasconcelos on 22/08/19.
//  Copyright © 2019 Luma Gabino Vasconcelos. All rights reserved.
//

import Foundation

enum Stage {
    case origin
    case destiny
}

class Path: NSObject {

    public var pathId: UUID?
    public var originAddress: String?
    public var originLat: Double?
    public var originLong: Double?
    public var originRadius: Double?
    public var destinyAddress: String?
    public var destinyLat: Double?
    public var destinyLong: Double?
    public var destinyRadius: Double?
    
    override init() {

    }
    
    init(pathId: UUID?, originLat: Double?, originLong: Double?, originRadius: Double?, destinyLat: Double?, destinyLong: Double?, destinyRadius: Double?) {
        self.pathId = pathId
        self.originLat = originLat
        self.originLong = originLong
        self.originRadius = originRadius
        self.destinyLat = destinyLat
        self.destinyLong = destinyLong
        self.destinyRadius = destinyRadius
    }
}
