//
//  CityPOIController.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/3/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit

protocol CategoryRowDelegate: class {
    func cellTapped()
}

class CityPOIController: UIViewController, CategoryRowDelegate {
        
    @IBOutlet weak var poiOverviewCollectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    let categories = ["Popular", "Architecture", "Culture", "Parks", "Romantic", "Restaurants"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()

        // Do any additional setup after loading the view.
    }
    
    func registerNib() {
        let categoriesNib = UINib(nibName: CategoryCollectionViewCell.nibName, bundle: nil)
        categoriesCollectionView?.register(categoriesNib, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
        if let flowLayout = self.categoriesCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        
        let poiNib = UINib(nibName: PoiOverviewCollectionViewCell.nibName, bundle: nil)
        poiOverviewCollectionView?.register(poiNib, forCellWithReuseIdentifier: PoiOverviewCollectionViewCell.reuseIdentifier)
        if let flowLayout = self.poiOverviewCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
    }
   
    
    func cellTapped() {
        print("click")
    }
}

extension CityPOIController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return categories.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.categoriesCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier, for: indexPath) as? CategoryCollectionViewCell {
                let name = categories[indexPath.row]
                cell.configureCell(name: name)
                return cell
            }
            return UICollectionViewCell()
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PoiOverviewCollectionViewCell.reuseIdentifier, for: indexPath) as? PoiOverviewCollectionViewCell {
                cell.configureCell(name: "Long test with many words Test")
                return cell
            }
            return UICollectionViewCell()
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        cellTapped()
    }
}

extension CityPOIController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.categoriesCollectionView {
            guard let cell: CategoryCollectionViewCell = Bundle.main.loadNibNamed(CategoryCollectionViewCell.nibName,
                                         owner: self,
                                         options: nil)?.first as? CategoryCollectionViewCell else {
                return CGSize.zero
            }
            cell.configureCell(name: categories[indexPath.row])
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            return CGSize(width: size.width, height: 30)
        } else {
            guard let cell: PoiOverviewCollectionViewCell = Bundle.main.loadNibNamed(PoiOverviewCollectionViewCell.nibName,
                                         owner: self,
                                         options: nil)?.first as? PoiOverviewCollectionViewCell else {
                return CGSize.zero
            }
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            return CGSize(width: size.width, height: 300)
        }
    }
}
