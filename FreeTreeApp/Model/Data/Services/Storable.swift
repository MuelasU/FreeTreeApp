//
//  Storable.swift
//  FreeTreeApp
//
//  Created by Gabriel Muelas on 23/06/22.
//

import Foundation

/// Implement logic for storing and retrieving data locally
protocol Storable: Codable {
    associatedtype Item: Storable

    /// Just the item type class' name lowercased
    static var itemName: String { get }
}

extension Storable {
    // MARK: - Mock public API

    /// Get all stored items
    static var store: [Item]? {
        if localMockExists {
            do {
                return try decode(from: url.path)
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        return initialData
    }

    /// Save item in store
    static func saveEntry(_ entry: Item) {
        guard var currentData = Self.store else { return }
        currentData.append(entry)

        do {
            let newData = try Encoder.shared.encode(currentData)
            try newData.write(to: url)
        } catch {
            print(error.localizedDescription)
        }
    }

    // MARK: - Private methods

    private static var localMockExists: Bool {
        FileManager.default.fileExists(atPath: url.path)
    }

    private static func decode(from path: String) throws -> [Item]? {
        let data = try String(contentsOfFile: path).data(using: .utf8)
        guard let data = data else { return nil }
        let decoded: [Item] = try Decoder.shared.decode(from: data)
        return decoded
    }

    private static var initialData: [Item]? {
        if let path = Bundle.main.path(forResource: itemName, ofType: "json") {
            do {
                return try decode(from: path)
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    private static var url: URL {
        FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        .appendingPathComponent(itemName + ".json")
    }
}
