//
//  MapViewController.swift
//  FreeTreeApp
//
//  Created by Caroline Andreoni Barcat Intaschi on 21/06/22.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    fileprivate var locationManager: CLLocationManager = CLLocationManager()
    var mapViewConfig: MapViewConfig?

    override func loadView() {
        self.view = MapView(delegate: self)
        mapViewConfig = self.view as? MapViewConfig
        followUserLocation()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func followUserLocation() {
        if let location = locationManager.location {
            let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
            mapViewConfig?.setRegion(region: region)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
            mapViewConfig?.setRegion(region: region)
        }
    }
}

extension MapViewController: MapViewDelegate {
    
}
