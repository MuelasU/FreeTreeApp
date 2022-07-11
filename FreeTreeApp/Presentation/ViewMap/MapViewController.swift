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

    private lazy var topConstraint: NSLayoutConstraint = sheetController.view.topAnchor.constraint(
        equalTo: self.view.topAnchor,
        constant: sheetHeightMode.offset
    )

    private var sheetHeightMode: SheetHeight = .short
    
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
            topConstraint,
            sheetController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 1000),
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
    
    @objc func showRegisterTreeVC () {
        let bridge = TreeRegisterViewModel()
        
        let userLong = locationManager.location?.coordinate.longitude as? Double ?? 0
        let userLat = locationManager.location?.coordinate.latitude as? Double ?? 0
        let vc = UIHostingController(rootView: TreeRegistrationView(TreeRegisterVM: bridge, lat: userLat, long: userLong))
        
        bridge.closeAction = { [weak vc] in
            vc?.dismiss(animated: true)
        }
        
        self.present(vc, animated: true, completion: nil)
    }
}

extension MapViewController: SheetDelegate {
    func didChangeHeight(to newHeight: SheetHeight) {
        sheetHeightMode = newHeight
        topConstraint.constant = sheetHeightMode.offset
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
    func didTapCreateTreeButton() {
        self.showRegisterTreeVC()
    }
}
