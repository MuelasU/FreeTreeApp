//
//  Tree.swift
//  FreeTreeApp
//
//  Created by Gabriel Muelas on 20/06/22.
//

import Foundation
import CoreLocation
import UIKit

struct Tree: Codable {
    let name: String
    let date: Date
    let tag: [String]
    let advices: [TreeAdvice]
    private let images: [String]
    private let coordinates: Location

    var treeImages: [UIImage?] {
        images.map { UIImage(named: $0) }
    }

    var location: CLLocation {
        CLLocation(latitude: coordinates.lat, longitude: coordinates.lng)
    }

    static func decode(from json: Data) -> [Tree]? {
        do {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormatter)

            let decodedData = try decoder.decode([Tree].self, from: json)
            return decodedData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

struct TreeAdvice: Codable {
    let username: String
    let date: Date
    let text: String
    private let avatar: String
    var avatarImage: UIImage? {
        UIImage(named: avatar)
    }
}

private struct Location: Codable {
    let lat: Double
    let lng: Double
}
