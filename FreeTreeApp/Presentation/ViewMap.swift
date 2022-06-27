//
//  ViewMap.swift
//  FreeTreeApp
//
//  Created by Caroline Andreoni Barcat Intaschi on 27/06/22.
//

import UIKit
import MapKit

protocol MapViewDelegate: AnyObject {
}

protocol MapViewConfig {
    func setRegion(region: MKCoordinateRegion)
}

final class MapView: UIView {
    weak var delegate: MapViewDelegate?
    
    init(delegate: MapViewDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        buildView()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.setUserTrackingMode(.followWithHeading, animated: true)
        return mapView
    }()
}

extension MapView: MapViewConfig {
    func setRegion(region: MKCoordinateRegion) {
        mapView.setRegion(region, animated: true)
    }
}

extension MapView: ViewCodeContract {
    func setupHierarchy() {
        addSubview(mapView)
    }
    
    func setupConstraints() {
        mapView.constraint { view in
            [view.topAnchor.constraint(equalTo: topAnchor),
             view.bottomAnchor.constraint(equalTo: bottomAnchor),
             view.leadingAnchor.constraint(equalTo: leadingAnchor),
             view.trailingAnchor.constraint(equalTo: trailingAnchor)]
        }
    }
    
    func additionalSetup() {
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = true
        mapView.isPitchEnabled = true
    }
}
