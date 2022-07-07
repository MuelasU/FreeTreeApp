//
//  SheetManager.swift
//  FreeTreeApp
//
//  Created by Pedro Haruke Leme da Rocha Rinzo on 05/07/22.
//

import SwiftUI

final class SheetManager: ObservableObject {
    
    enum Action {
        case noAviable
        case present
        case dismiss
    }
    
    @Published private(set) var action: Action = .noAviable
    
    func present() {
        self.action = .present
    }
    
    func dismiss() {
        self.action = .dismiss
    }
}

extension SheetManager.Action {
    var isPresented: Bool { self == .present }
}
