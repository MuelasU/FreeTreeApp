//
//  ExampleViewController.swift
//  FreeTreeApp
//
//  Created by Pedro Haruke Leme da Rocha Rinzo on 21/06/22.
//

import UIKit

class ExampleViewController: UIViewController {
    override func loadView() {
        self.view = ExampleView(delegate: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let currentData = Tree.store
        print(currentData)
        let treeTest = Tree(name: "Teste2", date: .now, tag: ["teste1", "teste2"], advices: [])
        Tree.saveEntry(treeTest)
        let newData = Tree.store
        print(newData)
    }
}

extension ExampleViewController: ExampleViewDelegate {
    func didTapExemploButton() {
        let viewController = ExampleViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
