//
//  SearchView.swift
//  FreeTreeApp
//
//  Created by Cesar Augusto Barros on 29/06/22.
//

import UIKit

protocol SearchViewDelegate: AnyObject {
    func didTapCell()
}

final class SearchView: UIView {
    private weak var delegate: SearchViewDelegate?
    init(delegate: SearchViewDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        buildView()
        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var treeLabel: UILabel = {
        let treeLabel = UILabel()
        treeLabel.text = "Árvores favoritas"
        treeLabel.textColor = .gray
        return treeLabel
    }()

    private lazy var searchButton: UIButton = {
        let overlayButton = UIButton(type: .custom)
        let magnifyingglass = UIImage(systemName: "magnifyingglass")
        overlayButton.setImage(magnifyingglass, for: .normal)
        overlayButton.tintColor = .gray
        return overlayButton
    }()

    private lazy var siriButton: UIButton = {
        let overlayButton = UIButton(type: .custom)
        let mic = UIImage(systemName: "mic")
        overlayButton.setImage(mic, for: .normal)
        overlayButton.tintColor = .gray
        return overlayButton
    }()

    private lazy var treeSearch: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .clear
        textField.leftView = searchButton
        textField.leftViewMode = .always
        textField.rightView = siriButton
        textField.rightViewMode = .always
        textField.placeholder = "Search"
        return textField
    }()

    private lazy var profileButton: UIButton = {
        let profilePicture = UIButton()
        let image = UIImage(named: "profilePicture")!
        profilePicture.setImage(image, for: .normal)
        return profilePicture
    }()
}

extension SearchView: ViewCodeContract {
    func setupHierarchy() {
        addSubview(treeSearch)
        addSubview(treeLabel)
        addSubview(profileButton)
    }

    func setupConstraints() {
        treeSearch.constraint { view in
            [
             view.topAnchor.constraint(equalTo: topAnchor, constant: 8),
             view.leftAnchor.constraint(equalTo: leftAnchor, constant: 8)]
        }
        treeLabel.constraint { view in
            [view.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
             view.topAnchor.constraint(equalTo: treeSearch.bottomAnchor, constant: 8)
            ]
        }
        profileButton.constraint { view in
            [view.topAnchor.constraint(equalTo: topAnchor, constant: 8),
             view.leftAnchor.constraint(equalTo: treeSearch.rightAnchor, constant: 8),
             view.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)
            ]
        }

    }
}
