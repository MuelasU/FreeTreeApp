//
//  Tag.swift
//  FreeTreeApp
//
//  Created by Ercília Regina Silva Dantas on 12/07/22.
//

import SwiftUI

struct Tag: Identifiable, Hashable {
    var id = UUID().uuidString
    var text: String
    var size: CGFloat = 0
}
