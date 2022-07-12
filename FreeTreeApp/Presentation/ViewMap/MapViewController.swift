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

class TreesStorage: ObservableObject {
    @Published var store: [Tree] = [] {
        didSet {
            //Update published
            favorites = favoritesTrees
        }
    }
    @Published var favorites: [Tree] = []
    
    struct Configuration {
        static let favoritesKey = "favorites"
    }
        
    private var user: UserDefaults {
        UserDefaults.standard
    }
    
    private var favoritesId: [String]? {
        user.array(forKey: Configuration.favoritesKey) as? [String]
    }
    
    func addToFavorites(tree: Tree) {
        if var favorites =  favoritesId {
            favorites.append(tree.id!)
            //Update user defaults
            user.set(favorites, forKey: Configuration.favoritesKey)
        } else {
            user.set([tree.id!], forKey: Configuration.favoritesKey)
        }
        //Update published
        self.favorites = favoritesTrees
    }
    
    private var favoritesTrees: [Tree] {
        guard let favoritesId = favoritesId else {
            return []
        }

        return store.filter { favoritesId.contains($0.id!) }
    }
}

class MapViewController: UIViewController {
    fileprivate var locationManager: CLLocationManager = CLLocationManager()
    var mapViewConfig: MapViewConfig?
    var treesStorage = TreesStorage()
    
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
        getTrees { trees in
            if let trees = trees {
                self.treesStorage.addToFavorites(tree: trees[0])
            }
        }
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

    public func getTrees(completion: @escaping ([Tree]?) -> Void) {
        let treeServices = TreeServices()
        treeServices.read { result in
            switch result {
            case let .success(trees):
                self.treesStorage.store = trees
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
                                                 latitudinalMeters: 100,
                                                 longitudinalMeters: 100)
            mapViewConfig?.setRegion(region: region)
        }
    }
}

extension MapViewController: MapViewDelegate {

}
