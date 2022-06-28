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
        
        treeService.create(tree: treeTest) { error in
            if let error = error {
                print("Não foi possível criar a árvore \(error.localizedDescription)")
            }
        }
        
        treeService.read { result in
            switch result {
            case let .success(trees):
                for tree in trees {
                    treeService.delete(tree: tree) { error in
                        if let error = error {
                            print("Não foi possível deletar a árvore \(error.localizedDescription)")
                        }
                    }
                }
            case let .failure(error):
                print("Não foi possível ler as árvores do banco \(error.localizedDescription)")
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
