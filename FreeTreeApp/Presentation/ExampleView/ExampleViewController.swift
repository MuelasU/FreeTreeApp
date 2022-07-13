//
// ExampleViewController.swift
// FreeTreeApp
//
// Created by Pedro Haruke Leme da Rocha Rinzo on 21/06/22.
//
import UIKit
class ExampleViewController: UIViewController {
  let treeService = TreeServices()
  override func loadView() {
    self.view = ExampleView(delegate: self)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    let images = [UIImage(systemName: "circle.fill")!, UIImage(systemName: "trash")!, UIImage(systemName: "plus")!, UIImage(systemName: "person.fill")!]
    let treeFB = TreeFB(name: "limoeiro da goiabeira", date: .now, tag: ["limão"], advices: [])
//    treeService.create(tree: treeFB, treeImages: images) { error in
//      if error != nil {
//        print("Não foi possivel gravar a árvore \(treeFB.name)")
//      } else {
//        print("Árvore gravada com sucesso")
//      }
//    }
    treeService.read { result in
      switch result {
      case let .success(trees):
        self.treeService.read(treeFB: trees[0]) { tree in
          print("Download: \(tree)")
        }
      case .failure:
        print("")
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
