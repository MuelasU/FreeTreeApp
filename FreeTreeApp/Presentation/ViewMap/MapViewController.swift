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
import Combine

class MapViewController: UIViewController {
    fileprivate var locationManager: CLLocationManager = CLLocationManager()
    var mapViewConfig: MapViewConfig?
    
    var sheetManager = SheetManager()
    var anyCancellables = Set<AnyCancellable>()
    private var ajustsViewController: UIViewController?

    override func loadView() {
        self.view = MapView(delegate: self)
        mapViewConfig = self.view as? MapViewConfig
        followUserLocation()
    }

    private lazy var topConstraint: NSLayoutConstraint = sheetController.view.topAnchor.constraint(
        equalTo: self.view.topAnchor,
        constant: sheetHeightMode.offset
    )
    private lazy var bottomConstraint: NSLayoutConstraint = sheetController.view.bottomAnchor.constraint(
        equalTo: self.view.bottomAnchor,
        constant: 0
    )

    private var sheetHeightMode: SheetHeight = .short
    
    private lazy var sheetController: UIViewController = {
        let sheet = Sheet(delegate: self, height: sheetHeightMode) {
            HomeView(viewModel: .init())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .environmentObject(self.sheetManager)
        
        self.sheetManager.$action.sink { action in
            switch action {
            case .present:
                self.presentAdjusts()
            case .dismiss:
                print(action)
                self.removeAdjusts()
            default:
                break
            }
        }
        .store(in: &anyCancellables)

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
            bottomConstraint,
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

extension MapViewController {
    private func presentAdjusts() {
        let popUpAjusts = PopUpAjustsView(didClose: {
            self.sheetManager.dismiss()
        })
        
        let hostingController = UIHostingController(rootView: popUpAjusts)
        self.ajustsViewController = hostingController
//        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(hostingController)
        view.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        sheetController.didMove(toParent: self)
    }
    
    private func removeAdjusts() {
        if let adjustsViewController = ajustsViewController {
            adjustsViewController.willMove(toParent: nil)
            adjustsViewController.view.removeFromSuperview()
            adjustsViewController.removeFromParent()
        }
    }
}

extension MapViewController: SheetDelegate {
    func didChangeHeight(to newHeight: SheetHeight) {
        sheetHeightMode = newHeight
        topConstraint.constant = sheetHeightMode.offset
        bottomConstraint.constant = 0
    }
    
    func didStartDragGesture() {
        bottomConstraint.constant = 1000
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
