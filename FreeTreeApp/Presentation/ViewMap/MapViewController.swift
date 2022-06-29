//
//  MapViewController.swift
//  FreeTreeApp
//
//  Created by Caroline Andreoni Barcat Intaschi on 27/06/22.
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

    override func viewDidAppear(_ animated: Bool) {
        let searchButton = UIButton(
            frame: CGRect(x: 0, y: UIScreen.main.bounds.midY, width: UIScreen.main.bounds.width, height: 80))
        searchButton.backgroundColor = .white
        searchButton.setTitle("Search", for: .normal)
        searchButton.addTarget(self, action: #selector(callSearchViewController), for: .touchUpInside)
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        self.view.addSubview(searchButton)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }

    func followUserLocation() {
        if let location = locationManager.location {
            let region = MKCoordinateRegion.init(center: location.coordinate,
                                                 latitudinalMeters: 100,
                                                 longitudinalMeters: 100)
            mapViewConfig?.setRegion(region: region)
        }
    }

    @objc func callSearchViewController() {
        let searchVC = SearchViewController()
        // searchVC.isModalInPresentation = true
        if let sheet = searchVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true

        }
        present(searchVC, animated: true, completion: nil)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let region = MKCoordinateRegion.init(center: location.coordinate,
                                                 latitudinalMeters: 100,
                                                 longitudinalMeters: 100)
            mapViewConfig?.setRegion(region: region)
        }
    }
}

extension MapViewController: MapViewDelegate {

}
