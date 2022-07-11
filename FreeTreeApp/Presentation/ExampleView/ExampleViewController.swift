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
        let storageService = StorageServices()
        let images = [UIImage(systemName: "circle.fill")!, UIImage(systemName: "trash")!, UIImage(systemName: "plus")!, UIImage(systemName: "person.fill")!]
        let treeService = TreeServices()
        let tree = Tree(name: "limoeiro da goiabeira", date: .now, tag: ["limão"], advices: [])
        treeService.create(tree: tree, treeImages: images) { error in
            if let error = error {
                print("Não foi possivel gravar a árvore \(tree.name)\n\(error.localizedDescription)")
            } else {
                print("Árvore gravada com sucesso")
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
