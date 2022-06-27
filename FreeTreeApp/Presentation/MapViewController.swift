//
//  MapViewController.swift
//  FreeTreeApp
//
//  Created by Caroline Andreoni Barcat Intaschi on 21/06/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    var mapConfig : MapViewConfig?
    let tree1 = TreeAnnotation(title: "Odin Tree", status: 1, coordinate: CLLocationCoordinate2D(latitude: -22.9519, longitude: -43.2105))
    let tree2 = TreeAnnotation(title: "Erci Tree", status: 2, coordinate: CLLocationCoordinate2D(latitude: -21.9505, longitude: -43.2105))
    let tree3 = TreeAnnotation(title: "Carol Tree", status: 3, coordinate: CLLocationCoordinate2D(latitude: -20.9510, longitude: -43.2105))
    
    override func loadView() {
        self.view = MapView(delegate: self)
        mapConfig = self.view as? MapViewConfig
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapConfig?.treePins([tree1, tree2, tree3])
    }
    
}

extension MapViewController: MapViewDelegate {    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? TreeAnnotation else {
          return nil
        }
   
        let identifier = "tree"
        var view: MKMarkerAnnotationView
 
        if let dequeuedView = mapView.dequeueReusableAnnotationView(
          withIdentifier: identifier) as? MKMarkerAnnotationView {
          dequeuedView.annotation = annotation
          view = dequeuedView
        } else {
          view = MKMarkerAnnotationView(
            annotation: annotation,
            reuseIdentifier: identifier)
          view.canShowCallout = true
          view.calloutOffset = CGPoint(x: -5, y: 5)
          view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
          
        return view
      }
    
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


