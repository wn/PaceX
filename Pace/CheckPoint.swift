//
//  LocatonTime.swift
//  Pace
//
//  Created by Yuntong Zhang on 16/3/19.
//  Copyright © 2019 nus.cs3217.pace. All rights reserved.
//

import Foundation

struct CheckPoint {
    private let location: Location
    private let time: Double
    private let actualDistance: Double
    private let routeDistance: Double?

    init(location: Location, time: Double, actualDistance: Double, routeDistance: Double) {
        self.location = location
        self.time = time
        self.actualDistance = actualDistance
        self.routeDistance = routeDistance
    }
}
