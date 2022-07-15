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
    @Published var store: [TreeFB] = []
}

class MapViewController: UIViewController {
    // TODO: Remove trees and use json
    let tree1 = TreeAnnotation(title: "Odin Tree", status: 1, coordinate: CLLocationCoordinate2D(latitude: -22.81359, longitude: -47.06185))
    let tree2 = TreeAnnotation(title: "Erci Tree", status: 2, coordinate: CLLocationCoordinate2D(latitude: -22.81179, longitude: -47.06565))
    let tree3 = TreeAnnotation(title: "Carol Tree", status: 3, coordinate: CLLocationCoordinate2D(latitude: -22.81519, longitude: -47.06225))
    fileprivate var locationManager: CLLocationManager = CLLocationManager()
    var mapViewConfig: MapViewConfig?
    var treesViewModel = TreeViewModel()
    var userAdress: String = ""
    
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
            HomeView(treeViewModel: self.treesViewModel)
                .frame(alignment: .top)
        }
        
        let hostingController = UIHostingController(rootView: sheet)
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        return hostingController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTrees { trees in
            print("Get \(String(describing: trees?.count)) trees")
        }
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
            bridge.closeAction = {
                self.getTrees(completion: { trees in
                    print("Get \(String(describing: trees?.count)) trees")
                })
            }
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

    public func getTrees(completion: @escaping ([TreeFB]?) -> Void) {
        let treeServices = TreeServices()
        treeServices.read { result in
            switch result {
            case let .success(trees):
                self.treesViewModel.store = trees
                completion(trees)
            case let .failure(error):
                print("Não foi possível ler as árvores do banco \(error.localizedDescription)")
                completion(nil)
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
                                                 latitudinalMeters: 800,
                                                 longitudinalMeters: 800)
            mapViewConfig?.setRegion(region: region)
        }
    }
}

extension MapViewController: MapViewDelegate {
    func didTapCreateTreeButton() {
        self.showRegisterTreeVC()
    }
}

