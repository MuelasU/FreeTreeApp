//
//  ExampleView.swift
//  FreeTreeApp
//
//  Created by Pedro Haruke Leme da Rocha Rinzo on 21/06/22.
//

import UIKit
import Firebase
protocol ExampleViewDelegate: AnyObject {
    func didTapExemploButton()
}

final class ExampleView: UIView {
    private weak var delegate: ExampleViewDelegate?
    let treeServices = TreeServices()
    init(delegate: ExampleViewDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        buildView()
        backgroundColor = .white
        
        //add data
        //treeServices.create(name: "bananinha")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var exemploDeLabel: UILabel = {
        let label = UILabel()
        label.text = "teste"
        label.font = .systemFont(ofSize: 45)
        
        return label
    }()
    
    private lazy var exemploDeButao: UIButton = {
        let button = UIButton()
        button.setTitle("Teste", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapExemploButton), for: .touchUpInside)
        
        return button
    }()
    
    @objc func didTapExemploButton() {
        delegate?.didTapExemploButton()
    }
}

extension ExampleView: ViewCodeContract {
    func setupHierarchy() {
        addSubview(exemploDeLabel)
        addSubview(exemploDeButao)
    }
    
    func setupConstraints() {
        exemploDeLabel.constraint { view in
            [view.centerXAnchor.constraint(equalTo: centerXAnchor),
             view.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100)]
        }
        exemploDeButao.constraint { view in
            [view.centerXAnchor.constraint(equalTo: centerXAnchor),
             view.centerYAnchor.constraint(equalTo: centerYAnchor)]
        }
    }
}
