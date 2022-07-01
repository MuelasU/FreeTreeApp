//
//  MapView.swift
//  FreeTreeApp
//
//  Created by Caroline Andreoni Barcat Intaschi on 21/06/22.
//

import UIKit
import MapKit

protocol MapViewDelegate: AnyObject {
}

protocol MapViewConfig: AnyObject {
    func treePins(_ treesInfo: [TreeAnnotation])
    
    func setRegion(region: MKCoordinateRegion)
}

final class MapView: UIView, MKMapViewDelegate {
    private weak var delegate: MapViewDelegate?
    
    init(delegate: MapViewDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        buildView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isPitchEnabled = true
        mapView.setUserTrackingMode(.followWithHeading, animated: true)
        mapView.register(TreeMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        return mapView
    }()
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let tree = view.annotation as? TreeAnnotation else {
            return
        }

        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ]
        tree.mapItem?.openInMaps(launchOptions: launchOptions)
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
}

extension MapView: MapViewConfig {
    func treePins(_ treesInfo: [TreeAnnotation]) {
        mapView.addAnnotations(treesInfo)
    }
    
    func setRegion(region: MKCoordinateRegion) {
        mapView.setRegion(region, animated: true)
    }
}
