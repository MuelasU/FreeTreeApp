//
//  CarouselView.swift
//  FreeTreeApp
//
//  Created by Cesar Augusto Barros on 30/06/22.
//

import Foundation
import UIKit

class CarouselView: UIView, UICollectionViewDelegate {

    struct CarouselData {
        let image: UIImage?
        let text: String
    }

    private lazy var carouselCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.showsHorizontalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .clear
        return collection
    }()

    private lazy var pageControl: UIPageControl = {
       let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .orange
        pageControl.currentPageIndicatorTintColor = .orange
        return pageControl
    }()

    private var carouselData = [CarouselData]()
    private var currentPage = 0
    
    let carouselView = CarouselView()
}

extension CarouselView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return carouselData.count
       }
    // swiftlint:disable:next line_length
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CarouselCell.cellId, for: indexPath
        ) as? CarouselCell else {
            return UICollectionViewCell()

        }

        let image = carouselData[indexPath.row].image
        let text = carouselData[indexPath.row].text

        cell.configure(image: image, text: text)

        return cell
    }
}

extension CarouselView {
    public func configureView(with data: [CarouselData]) {
        let carouselLayout = UICollectionViewFlowLayout()
        carouselLayout.scrollDirection = .horizontal
        carouselLayout.itemSize = .init(width: 300, height: 400)
        carouselLayout.sectionInset = .zero
        carouselCollectionView.collectionViewLayout = carouselLayout

        carouselData = data
        carouselCollectionView.reloadData()
    }
}
