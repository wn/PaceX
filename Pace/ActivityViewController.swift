//
//  RunningViewController.swift
//  Pace
//
//  Created by Ang Wei Neng on 27/3/19.
//  Copyright © 2019 nus.cs3217.pace. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import AVFoundation

class ActivityViewController: UIViewController {
    @IBOutlet private var mapView: GMSMapView!
    // Keep track of all markers in the map
    // Int to change to run details instead.
    var markers: [GMSMarker: Int] = [:]

    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        setupMapView()
    }

    /// Set up mapView view.
    private func setupMapView() {
        mapView.animate(toZoom: Constants.initialZoom)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true

        // Required to activate gestures in mapView
        mapView.settings.consumesGesturesInView = false
        mapView.delegate = self
        mapView.setMinZoom(Constants.minZoom, maxZoom: Constants.maxZoom)
    }

    /// Set up location manager from CoreLocation.
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestLocation()
        while locationManager.location == nil {
            // Wait 1 second and check if location has been loaded.
            // If location cannot be loaded, code here will never terminate
            // TODO: FIX ABOVE
            sleep(1)
        }
        guard let location = locationManager.location else {
            fatalError("While loop should have captured nil value!")
        }
        mapView.setCameraPosition(location.coordinate)
    }

    @IBAction private func startRun(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let runVC =
            storyBoard.instantiateViewController(
                withIdentifier: "runVC")
                as! RunningViewController
        renderChildController(runVC)
    }

    func getNearbyRoutes() -> [CLLocation] {
        let topLeft = mapView.projection.visibleRegion().farLeft
        let bottomRight = mapView.projection.visibleRegion().nearRight

        // Bounds of maps to retrieve
        let top = topLeft.latitude
        let bottom = bottomRight.latitude
        let left = topLeft.longitude
        let right = bottomRight.longitude

        // TODO: Fake data. To draw real data here instead
        let one = CLLocation(latitude: bottom + 0.001, longitude: left)
        let two = CLLocation(latitude: bottom + 0.000_5, longitude: left)
        let three = CLLocation(latitude: top - 0.001, longitude: right)
        let four = CLLocation(latitude: top - 0.000_5, longitude: right)
        return [one, two, three, four]
    }

    func generateRouteMarker(location: CLLocation, count: Int) -> GMSMarker {
        let marker = GMSMarker(position: location.coordinate)
        marker.map = mapView
        marker.icon = UIImage(named: "\(count)")
        return marker
    }
}

// MARK: - CLLocationManagerDelegate
extension ActivityViewController: CLLocationManagerDelegate {
    /// Function from CLLocationManagerDelegate.
    /// Check if there was any change to the authorization level
    /// for location and handle the change.
    ///
    /// - Parameters:
    ///   - manager: The location manager for the view-controller.
    ///   - status: The newly set location authorization level.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            return
        }
        locationManager.requestWhenInUseAuthorization()
    }

    /// Function from CLLocationManagerDelegate.
    /// Empty function as we do not do anything about the
    /// location result. 
    ///
    /// - Parameters:
    ///   - manager: The location manager for the view-controller.
    ///   - locations: The array of location updates that is not handled yet.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        return
    }

    /// Function from CLLocationManagerDelegate.
    /// Function to handle failure in retrieving location.
    ///
    /// - Parameters:
    ///   - manager: The location manager for the view-controller.
    ///   - error: Error message.
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        // isConnected = false
    }
}

// MARK: - GMSMapViewDelegate
extension ActivityViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        // TODO: On tap with marker, pop up route description
        guard let markerID = markers[marker] else {
            redrawMarkers(mapView.camera.target)
            return false
        }
        let alert = UIAlertController(
            title: "TAPPED MARKER",
            message: "tapped marker \(markerID)",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
        return true
    }

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        redrawMarkers(mapView.camera.target)
    }

    func redrawMarkers(_ location: CLLocationCoordinate2D) {
        mapView.clear()
        markers = [:]
        guard mapView.camera.zoom > Constants.minZoomToShowRoutes else {
            return
        }

        // TODO: Get all potential markers and generate them.
        // Get marker nearby location
        let routes = getNearbyRoutes()
        markers = [:]
        for index in 0..<routes.count {
            // Count is the number of routes that the marker represents
            // Set as 17 as that is the name of the image
            let count = 17
            let marker = generateRouteMarker(location: routes[index], count: count)
            markers[marker] = index
        }
    }

    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        guard let location = locationManager.location else {
            return false
        }
        mapView.setCameraPosition(location.coordinate)
        mapView.animate(toZoom: Constants.initialZoom)
        return true
    }
}
