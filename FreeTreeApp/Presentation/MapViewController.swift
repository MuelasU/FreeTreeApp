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
    let tree1 = TreeAnnotation(title: "Odin Tree", status: 1, coordinate: CLLocationCoordinate2D(latitude: -22.9519, longitude: -43.2105))
    let tree2 = TreeAnnotation(title: "Erci Tree", status: 2, coordinate: CLLocationCoordinate2D(latitude: -22.950, longitude: -43.2105))
    let tree3 = TreeAnnotation(title: "Carol Tree", status: 3, coordinate: CLLocationCoordinate2D(latitude: -22.9490, longitude: -43.2105))
    fileprivate var locationManager: CLLocationManager = CLLocationManager()
    var mapConfig : MapViewConfig?
    
    override func loadView() {
        self.view = MapView(delegate: self)
        mapConfig = self.view as? MapViewConfig
        followUserLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        locationManager.requestWhenInUseAuthorization()
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.distanceFilter = kCLDistanceFilterNone
                locationManager.startUpdatingLocation()
                locationManager.delegate = self
        
        mapConfig?.treePins([tree1, tree2, tree3])
    }
    
    func followUserLocation() {
            if let location = locationManager.location {
                let region = MKCoordinateRegion.init(center: location.coordinate,
                                                     latitudinalMeters: 100,
                                                     longitudinalMeters: 100)
                mapConfig?.setRegion(region: region)
            }
        }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let region = MKCoordinateRegion.init(center: location.coordinate,
                                                 latitudinalMeters: 100,
                                                 longitudinalMeters: 100)
            mapConfig?.setRegion(region: region)
        }
    }
}

extension MapViewController: MapViewDelegate {    

}


