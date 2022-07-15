//
//  TreeMarkerView.swift
//  FreeTreeApp
//
//  Created by Ercília Regina Silva Dantas on 23/06/22.
//

import Foundation
import MapKit

class TreeMarkerView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let tree = newValue as? TreeAnnotation else {
                return
            }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: -5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            image = tree.image
        }
    }
}
