//
//  Pace.swift
//  Pace
//
//  Created by Yuntong Zhang on 16/3/19.
//  Copyright © 2019 nus.cs3217.pace. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

class Run: IdentifiableObject {
    @objc dynamic var runner: User?
    @objc dynamic var dateCreated = Date()
    @objc dynamic var timeSpent: Double = 0.0
    var checkpoints = List<CheckPoint>()

    // computed properties, ignored by Realm
    var startingLocation: CLLocation? {
        return checkpoints.first?.location
    }
    var totalDistance: Double? {
        return checkpoints.last?.routeDistance
    }
    // TODO: test map and compactMap for Realm List
    var locations: [CLLocation] {
        return checkpoints.compactMap { $0.location }
    }

    /// Constructs a Run with the given runner and checkpoints.
    /// - Parameters:
    ///   - runner: The runner of this Run.
    ///   - checkpoints: The array of normalized checkpoints for this Run.
    convenience init(runner: User, checkpoints: [CheckPoint]) {
        self.init()
        guard let lastPoint = checkpoints.last else {
            return
        }
        self.runner = runner
        self.timeSpent = lastPoint.time
        self.checkpoints = {
            let checkpointsList = List<CheckPoint>()
            checkpointsList.append(objectsIn: checkpoints)
            return checkpointsList
        }()
    }

    /// Gets the latitude and longitude boundaries for this run.
    /// - Returns: A tuple of range of latitude and range of longitude.
    func getBoundaries() -> (ClosedRange<CLLocationDegrees>, ClosedRange<CLLocationDegrees>) {
        let latitudes = locations.map { $0.latitude }
        let longitudes = locations.map { $0.longitude }
        guard let minLatitude = latitudes.min(),
            let maxLatitude = latitudes.max(),
            let minLongitude = longitudes.min(),
            let maxLongitude = longitudes.max() else {
                fatalError("There should be locations in the run.")
        }
        return (latitudeRange: minLatitude...maxLatitude, longitudeRange: minLongitude...maxLongitude)
    }

    /// Normalizes an array of CheckPoints based on the checkPoints array of this Run.
    /// - Precondition: the given runner record does not deviate from this Run.
    /// - Parameter runnerRecords: the array of CheckPoints to be normalized.
    /// - Returns: an array of normalized CheckPoints.
    func normalize(_ runnerRecords: [CheckPoint]) -> [CheckPoint] {
        return checkpoints.map { basePoint in
            basePoint.extractNormalizedPoint(from: runnerRecords)
        }
    }
}
