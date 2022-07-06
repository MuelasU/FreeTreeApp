//
//  MapViewController.swift
//  FreeTreeApp
//
//  Created by Caroline Andreoni Barcat Intaschi on 27/06/22.
//

import UIKit
import MapKit
import CoreLocation
import SwiftUI

class MapViewController: UIViewController {
    fileprivate var locationManager: CLLocationManager = CLLocationManager()
    var mapViewConfig: MapViewConfig?

    override func loadView() {
        self.view = MapView(delegate: self)
        mapViewConfig = self.view as? MapViewConfig
        followUserLocation()
    }

    private lazy var heightConstraint: NSLayoutConstraint = sheetController.view.heightAnchor.constraint(
        equalToConstant: UIScreen.main.bounds.height - sheetHeightMode.offset
    )

    private var sheetHeightMode: SheetHeight = .tall
    
    private lazy var sheetController: UIViewController = {
        let sheet = Sheet(delegate: self, height: sheetHeightMode) {
            HomeView(viewModel: .init())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }

        let hostingController = UIHostingController(rootView: sheet)
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        return hostingController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(sheetController)
        view.addSubview(sheetController.view)

        NSLayoutConstraint.activate([
            heightConstraint,
            sheetController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sheetController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        sheetController.didMove(toParent: self)
        
        configureLocationManager()
    }
    
    private func configureLocationManager() {
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
}

extension MapViewController: SheetDelegate {
    func didChangeHeight(to newHeight: SheetHeight) {
        sheetHeightMode = newHeight
        heightConstraint.constant = UIScreen.main.bounds.height - sheetHeightMode.offset
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
