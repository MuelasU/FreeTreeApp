//
//  MapViewController.swift
//  FreeTreeApp
//
//  Created by Caroline Andreoni Barcat Intaschi on 21/06/22.
//
import UIKit
import MapKit
import CoreLocation
import SwiftUI

class TreesStorage: ObservableObject {
    @Published var store: [Tree] = []
}

class MapViewController: UIViewController {
    // TODO: Remove trees and use json
    let tree1 = TreeAnnotation(title: "Odin Tree", status: 1, coordinate: CLLocationCoordinate2D(latitude: -22.9519, longitude: -43.2105))
    let tree2 = TreeAnnotation(title: "Erci Tree", status: 2, coordinate: CLLocationCoordinate2D(latitude: -22.950, longitude: -43.2105))
    let tree3 = TreeAnnotation(title: "Carol Tree", status: 3, coordinate: CLLocationCoordinate2D(latitude: -22.9490, longitude: -43.2105))
    fileprivate var locationManager: CLLocationManager = CLLocationManager()
    var mapViewConfig: MapViewConfig?
    var userAdress: String = ""
    var treesStorage = TreesStorage()
    
    override func loadView() {
        self.view = MapView(delegate: self)
        mapViewConfig = self.view as? MapViewConfig
        followUserLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }

    private lazy var topConstraint: NSLayoutConstraint = sheetController.view.topAnchor.constraint(
        equalTo: self.view.topAnchor,
        constant: sheetHeightMode.offset
    )

    private var sheetHeightMode: SheetHeight = .short
    
    private lazy var sheetController: UIViewController = {
        let sheet = Sheet(delegate: self, height: sheetHeightMode) {
            HomeView(viewModel: .init(), treesStorage: self.treesStorage)
                .frame(alignment: .top)
        }
        
        let hostingController = UIHostingController(rootView: sheet)
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        return hostingController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTrees(completion: {_ in print("Yes")})

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
      
        mapViewConfig?.treePins([tree1, tree2, tree3])
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
        lookUpCurrentLocation { address in
            let bridge = TreeRegisterViewModel()
            let userLong = self.locationManager.location?.coordinate.longitude as? Double ?? 0
            let userLat = self.locationManager.location?.coordinate.latitude as? Double ?? 0
            
            let vc = UIHostingController(rootView: TreeRegistrationView(TreeRegisterVM: bridge, lat: userLat, long: userLong, userAdress: address))
            
            bridge.closeAction = { [weak vc] in
                vc?.dismiss(animated: true)
            }
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func lookUpCurrentLocation(completionHandler: @escaping (String)
                               -> Void ) {
        // Use the last reported location.
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
            
            // Look up the location and return completion with address
            geocoder.reverseGeocodeLocation(lastLocation,
                                            completionHandler: { (placemarks, error) in
                
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    
                    self.userAdress = addressString
                    completionHandler(addressString)
                    print(addressString)
                }
            })
        }
        else {
            // No location was available.
            completionHandler("Wasn't able to get your location")
        }
    }
            
    @objc func openSwiftUIScreen() {
        let swiftUIViewController = UIHostingController(rootView: HomeView(navigationController: self.navigationController, viewModel: .init(), treesStorage: treesStorage))
        self.navigationController?.pushViewController(swiftUIViewController, animated: true)
    }

    public func getTrees(completion: ([Tree]) -> Void) {
        let treeServices = TreeServices()
        treeServices.read { result in
            switch result {
            case let .success(trees):
                self.treesStorage.store = trees
            case let .failure(error):
                print("Não foi possível ler as árvores do banco \(error.localizedDescription)")
            }
        }
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

