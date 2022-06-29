//
//  searchViewController.swift
//  FreeTreeApp
//
//  Created by Cesar Augusto Barros on 27/06/22.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let exampleTrees = [
        ["Laranjeira Planalto", "Não gostei, estavam muito azedas!", "8 km de distância"],
        ["Laranjeira Planalto", "Achei perfeita para um date", "12 km de distância"],
        ["Laranjeira Planalto", "Show Levei 6 para casa", "15 km de distância"]
    ]

    let tableView = UITableView()
    var treeList = [[String]]()
    var name: UILabel?
    var comments: UILabel?
    var distance: UILabel?
    var picture: UIImageView?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return treeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let theTree = treeList[indexPath.row]
        cell.textLabel?.text = treeList[indexPath.row][0]
        cell.detailTextLabel?.text = treeList[indexPath.row][1]
        cell.imageView!.image = UIImage(named: "treeExampleAsset")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Todas as árvores"
    }

    func favorites() {
        let title: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        title.center = CGPoint(x: 160, y: 285)
        title.textAlignment = .left
        title.text = "Árvores favoritas"
        self.view.addSubview(title)
    }

    func allTrees () {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        for index in 0 ... exampleTrees.count - 1 {
            treeList.append(exampleTrees[index])
        }

        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.white
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "TreeCellType", bundle: nil), forCellReuseIdentifier: "cell")
        allTrees()

    }

    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let yCoord = self.view.frame.minY
        self.view.frame = CGRect(x: 0, y: yCoord + translation.y, width: view.frame.width, height: view.frame.height)
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
}
