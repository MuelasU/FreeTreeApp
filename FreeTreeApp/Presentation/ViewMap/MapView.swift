//
//  ViewMap.swift
//  FreeTreeApp
//
//  Created by Caroline Andreoni Barcat Intaschi on 27/06/22.
//

import UIKit
import MapKit

protocol MapViewDelegate: AnyObject {
    func didTapCreateTreeButton()
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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var mapView: MKMapView = {
        let mapView = MKMapView()

        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isPitchEnabled = true
        mapView.setUserTrackingMode(.followWithHeading, animated: true)

        return mapView
    }()
    
    var button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "treeIcon"), for: .normal)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapCreateTreeButton), for: .touchUpInside)

        return button
    }()
    
    @objc func didTapCreateTreeButton() {
        delegate?.didTapCreateTreeButton()
    }
}

extension MapView: MapViewConfig {
    func setRegion(region: MKCoordinateRegion) {
        mapView.setRegion(region, animated: true)
    }
}

extension MapView: ViewCodeContract {
    func setupHierarchy() {
        addSubview(mapView)
        addSubview(button)
    }

    func setupConstraints() {
        mapView.constraint { view in
            [view.topAnchor.constraint(equalTo: topAnchor),
             view.bottomAnchor.constraint(equalTo: bottomAnchor),
             view.leadingAnchor.constraint(equalTo: leadingAnchor),
             view.trailingAnchor.constraint(equalTo: trailingAnchor)]
        }
        
        button.constraint { view in
            [view.topAnchor.constraint(equalTo: topAnchor, constant: 60),
             view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)]
        }
    }
}
