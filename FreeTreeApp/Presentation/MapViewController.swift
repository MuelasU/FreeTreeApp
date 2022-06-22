//
//  MapViewController.swift
//  FreeTreeApp
//
//  Created by Caroline Andreoni Barcat Intaschi on 21/06/22.
//

import UIKit

class MapViewController: UIViewController {
    override func loadView() {
        self.view = MapView(delegate: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MapViewController: MapViewDelegate {
    
}
