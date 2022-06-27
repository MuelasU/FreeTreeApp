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
        let treeTest = Tree(name: "laranjeira do norte", date: .now, tag: ["a, b"], advices: [])
        let treeService = TreeServices()
        //Tenta inserir uma árvore no banco
        //treeService.create(tree: treeTest)
        //Carrega todas as árvores do banco
        treeService.read { result in
            switch result {
            case let .success(trees):
                print(trees)
            case let .failure(error):
                print(error)
            }
        }
    }
}

extension ExampleViewController: ExampleViewDelegate {
    func didTapExemploButton() {
        let viewController = ExampleViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
