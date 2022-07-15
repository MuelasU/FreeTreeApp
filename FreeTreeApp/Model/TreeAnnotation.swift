//
//  TreeAnnotation.swift
//  FreeTreeApp
//
//  Created by Ercília Regina Silva Dantas on 22/06/22.
//

import Foundation
import MapKit
import Contacts

enum NewStatus: Int, CaseIterable {
    case favorite = 1
    case known = 2
    case unknown = 3
}

class TreeAnnotation: NSObject, MKAnnotation {
    let title: String?
    let status: Int?
    let coordinate: CLLocationCoordinate2D

    init(title: String?, status: Int?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.status = status
        self.coordinate = coordinate

        super.init()
    }

    var image: UIImage {
        switch status {
        case 1:
            return UIImage(named: "treePinFavorite")!
        case 2:
            return UIImage(named: "treePinKnown")!
        default:
            return UIImage(named: "treePinUnknown")!
        }
    }

    var mapItem: MKMapItem? {
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
