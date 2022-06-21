//
//  ViewCoding.swift
//  FreeTreeApp
//
//  Created by Pedro Haruke Leme da Rocha Rinzo on 21/06/22.
//

import Foundation

protocol ViewCodeContract {
    func setupHierarchy()
    func setupConstraints()
    func additionalSetup()

    func buildView()
}

extension ViewCodeContract {
    func buildView() {
        setupHierarchy()
        setupConstraints()
        additionalSetup()
    }

    func additionalSetup() { }
}
