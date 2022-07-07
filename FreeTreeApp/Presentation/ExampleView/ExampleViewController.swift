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
        let treeTest = Tree(name: "limoeiro do norte", date: .now, tag: ["a, b"], advices: [])
        let treeService = TreeServices()
        treeService.testes(tree: treeTest)
    }
}

extension ExampleViewController: ExampleViewDelegate {
    func didTapExemploButton() {
        let viewController = ExampleViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
