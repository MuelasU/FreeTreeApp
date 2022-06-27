//
//  MapView.swift
//  FreeTreeApp
//
//  Created by Caroline Andreoni Barcat Intaschi on 21/06/22.
//

import UIKit
import MapKit

protocol MapViewDelegate: AnyObject {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation)-> MKAnnotationView? 
}

protocol MapViewConfig: AnyObject {
    func treePins(_ treesInfo: [TreeAnnotation])
}

final class MapView: UIView, MKMapViewDelegate {
    private weak var delegate: MapViewDelegate?
    
    init(delegate: MapViewDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        buildView()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.register(TreeMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
 
        return mapView
    }()
    
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
}

extension MapView: MapViewConfig {
    func treePins(_ treesInfo: [TreeAnnotation]) {
       mapView.delegate = self
       mapView.addAnnotations(treesInfo)
   }
}
