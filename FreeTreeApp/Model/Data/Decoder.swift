//
//  Decoder.swift
//  FreeTreeApp
//
//  Created by Gabriel Muelas on 22/06/22.
//

import Foundation

class Decoder {
    static let shared: Decoder = .init()

    private let decoder: JSONDecoder

    private init() {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        self.decoder = decoder
    }

    func decode<T: Decodable>(from json: Data) throws -> T {
        try decoder.decode(T.self, from: json)
    }
}

class Encoder {
    static let shared: Encoder = .init()

    private let encoder: JSONEncoder

    private init() {
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        self.encoder = encoder
    }

    func encode<T: Encodable>(_ object: T) throws -> Data {
        try encoder.encode(object)
    }
}

protocol Mockable: Codable {
    associatedtype U: Mockable

    static var mockName: String { get }
}

extension Mockable {
    static var data: [U]? {
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

    static func saveEntry(_ entry: U) {
        guard var currentData = Self.data else { return }
        currentData.append(entry)

        do {
            let newData = try Encoder.shared.encode(currentData)
            try newData.write(to: url)
        } catch {
            print(error.localizedDescription)
        }
    }

    private static var localMockExists: Bool {
        FileManager.default.fileExists(atPath: url.path)
    }

    private static func decode(from path: String) throws -> [U]? {
        let data = try String(contentsOfFile: path).data(using: .utf8)
        guard let data = data else { return nil }
        let decoded: [U] = try Decoder.shared.decode(from: data)
        return decoded
    }

    private static var initialData: [U]? {
        if let path = Bundle.main.path(forResource: mockName, ofType: "json") {
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
        .appendingPathComponent(mockName + ".json")
    }

}
