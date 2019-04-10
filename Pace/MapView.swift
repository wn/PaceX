//
//  MapView.swift
//  Pace
//
//  Created by Ang Wei Neng on 5/4/19.
//  Copyright © 2019 nus.cs3217.pace. All rights reserved.
//

import UIKit
import GoogleMaps

class MapView: GMSMapView {
    private var gridMapManager = Constants.defaultGridManager
    private var path = GMSMutablePath()
    private var currentMapPath: GMSPolyline?

    public func setup() {
        animate(toZoom: Constants.initialZoom)
        isMyLocationEnabled = true
        settings.myLocationButton = true

        // Required to activate gestures in googleMapView
        settings.consumesGesturesInView = false
        setMinZoom(Constants.minZoom, maxZoom: Constants.maxZoom)
    }

    /// Add an image to the map. Required to plot start and end flag.
    ///
    /// - Parameters:
    ///   - image: Image of marker.
    ///   - position: position to plot the image.
    public func addMarker(_ image: String, position: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: position)
        marker.map = self
        marker.icon = UIImage(named: image)
    }

    public func addPositionToRoute(_ position: CLLocationCoordinate2D) {
        path.add(position)
        currentMapPath?.map = nil
        currentMapPath = routeDrawing(path)
    }

    private func routeDrawing(_ path: GMSMutablePath) -> GMSPolyline {
        let drawing = GMSPolyline(path: path)

        drawing.strokeColor = .blue
        drawing.strokeWidth = 5
        drawing.map = self

        return drawing
    }

    public func startRun(at position: CLLocationCoordinate2D) {
        clear()
        path.add(position)
        addMarker(Constants.startFlag, position: position)
    }

    public func completeRun() {
        path.removeAllCoordinates()
        currentMapPath?.map = nil
        currentMapPath = nil
        clear()
    }

    var viewingGrids: [GridNumber] {
        guard zoom > Constants.minZoomToShowRoutes else {
            return []
        }
        return gridMapManager.getBoundedGrid(projectedMapBound)
    }

    var zoom: Float {
        return camera.zoom
    }

    var projectedMapBound: GridBound {
        let topLeft = projection.visibleRegion().farLeft
        let topRight = projection.visibleRegion().farRight
        let bottomLeft = projection.visibleRegion().nearLeft
        let bottomRight = projection.visibleRegion().nearRight
        return GridBound(topLeft: topLeft, topRight: topRight, bottomLeft: bottomLeft, bottomRight: bottomRight)
    }
}
