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
    private let avatar: String
    var avatarImage: UIImage? {
        UIImage(named: avatar)
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

struct Tree: Mockable, UpdatableIdentifiable {
    typealias U = Self
    static var mockName: String = "tree"
    @DocumentID var id: String?
    let name: String
    let date: Date
    let tag: [String]
    let advices: [TreeAdvice]
    var coordinates: Location = Location(lat: 0, lgt: 0)
    private var images: [String] = []

    init(name: String, date: Date, tag: [String], advices: [TreeAdvice]) {
        self.name = name
        self.date = date
        self.tag = tag
        self.advices = advices
    }

    var treeImages: [UIImage?] {
        get { images.map { UIImage(named: $0) } }
        // TODO: implement set logic: save images
    }

    var location: CLLocationCoordinate2D {
        get { CLLocationCoordinate2D(latitude: coordinates.lat, longitude: coordinates.lgt) }
        set { coordinates = Location(lat: newValue.latitude, lgt: newValue.longitude) }
    }
}
