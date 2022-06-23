//
//  Decoder.swift
//  FreeTreeApp
//
//  Created by Gabriel Muelas on 22/06/22.
//

import Foundation

/// Standard responsible for decoding data. Use the singleton instance `shared`
class Decoder {
    static let shared: Decoder = .init()

    private let decoder: JSONDecoder

    private init() {
        let dateFormatter = DateFormatter()
        let decoder = JSONDecoder()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        self.decoder = decoder
    }

    func decode<T: Decodable>(from json: Data) throws -> T {
        try decoder.decode(T.self, from: json)
    }
}

/// Standard responsible for encoding data. Use the singleton instance `shared`
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
