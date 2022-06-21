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

        getTrees()
    }

    private func getTrees() {
        if
            let path = Bundle.main.path(forResource: "mock_test", ofType: "json"),
            let json = try? String(contentsOfFile: path).data(using: .utf8)
        {
            let trees = Tree.decode(from: json)
            print(trees!)
        }
    }
}

extension ExampleViewController: ExampleViewDelegate {
    func didTapExemploButton() {
        let viewController = ExampleViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
