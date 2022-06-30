//
//  CarouselCell.swift
//  FreeTreeApp
//
//  Created by Cesar Augusto Barros on 30/06/22.
//

import Foundation
import UIKit

class CarouselCell: UICollectionViewCell {
    private lazy var imageView = UIImageView()
    private lazy var textLabel = UILabel()

    static let cellId = "CarouselCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

private extension CarouselCell {
    func setupUI() {
        backgroundColor = .clear

        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10

        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        textLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: 16).isActive = true
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .left
        textLabel.font = .systemFont(ofSize: 12)
        textLabel.textColor = .black
    }
}

extension CarouselCell {
    public func configure(image: UIImage?, text: String) {
        imageView.image = image
        textLabel.text = text
    }
}
