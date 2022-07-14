//
//  Tree.swift
//  FreeTreeApp
//
//  Created by Gabriel Muelas on 20/06/22.
//

import Foundation
import CoreLocation
import UIKit
import FirebaseFirestoreSwift

struct TreeAdvice: Codable {
    let username: String
    let date: Date
    let text: String
    private let avatar: String?

    var avatarImage: UIImage {
        get {
            guard let avatar = avatar else {
                return UIImage(systemName: "person.crop.circle")!
            }
            return UIImage(named: avatar)!
        }
        // TODO: - Implement setter
    }
}

struct Location: Codable {
    let lat: Double
    let lgt: Double

    static let zero = Location(lat: 0, lgt: 0)
}

protocol UpdatableIdentifiable: Identifiable {


    /// The stable identity of the entity associated with this instance.
    var id: Self.ID { get set }
}

struct TreeFB: Storable, UpdatableIdentifiable {
    typealias Item = Self
    static var itemName: String = "tree"
    @DocumentID var id: String?
    let name: String
    let date: Date
    let tag: [String]
    let advices: [TreeAdvice]
    var coordinates: Location = Location(lat: 0, lgt: 0)
    //uuid de cada imagem
    var imagesID: [String] = []
    
    init(name: String, date: Date, tag: [String], advices: [TreeAdvice]) {
        self.name = name
        self.date = date
        self.tag = tag
        self.advices = advices
    }
    
    var location: CLLocationCoordinate2D {
        get { CLLocationCoordinate2D(latitude: coordinates.lat, longitude: coordinates.lgt) }
        set { coordinates = Location(lat: newValue.latitude, lgt: newValue.longitude) }
    }
}




