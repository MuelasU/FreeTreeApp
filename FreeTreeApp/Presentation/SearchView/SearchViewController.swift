//
//  searchViewController.swift
//  FreeTreeApp
//
//  Created by Cesar Augusto Barros on 27/06/22.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    override func loadView() {
        self.view = SearchView(delegate: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // let currentData = Tree.store
        let treeTest = Tree(name: "Exemplo", date: .now, tag: ["Tag1", "Tag2"], advices: [])
        Tree.saveEntry(treeTest)
        print(treeTest)
        // let newData = Tree.store
    }
}

extension SearchViewController: SearchViewDelegate {
    func didTapCell() {
        let viewController = SearchViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
