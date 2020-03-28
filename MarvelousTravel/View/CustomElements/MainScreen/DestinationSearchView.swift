//
//  DestinationSearchView.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/23/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit
import BFWControls
import SHSearchBar


class DestinationSearchView: NibView, SHSearchBarDelegate {

    @IBOutlet weak var popularDestinationsLabel: UILabel!
    @IBOutlet weak var helloTextLabel: UILabel!
    @IBOutlet weak var searchBarContainer: UIStackView!
    @IBOutlet weak var citiesCollectionView: UICollectionView!
    @IBOutlet weak var searchBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var helloTextTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBarToTextConstraint: NSLayoutConstraint!
    
    var searchBar: SHSearchBar!
    var rasterSize: CGFloat = 11.0
    var storedConstraintValue: CGFloat?
    
    let searchbarHeight: CGFloat = 44.0
    let viewModel = DestinationSearchViewModel()
    
    override func willMove(toSuperview newSuperview: UIView?) {
        setupConstraints()
        setupCollectionView()
        
        searchBar = defaultSearchBar(withRasterSize: rasterSize,
                                      leftView: nil,
                                      rightView: nil,
                                      delegate: self)
        
        searchBarContainer.addArrangedSubview(searchBar)
    }
    
    func defaultSearchBar(withRasterSize rasterSize: CGFloat,
                          leftView: UIView?,
                          rightView: UIView?,
                          delegate: SHSearchBarDelegate,
                          useCancelButton: Bool = true) -> SHSearchBar {

        var config = defaultSearchBarConfig(rasterSize)
        config.leftView = leftView
        config.rightView = rightView
        config.useCancelButton = useCancelButton

        if leftView != nil {
            config.leftViewMode = .always
        }

        if rightView != nil {
            config.rightViewMode = .unlessEditing
        }

        let bar = SHSearchBar(config: config)
        bar.delegate = delegate
        bar.placeholder = "Find city"
        bar.updateBackgroundImage(withRadius: 6, corners: [.allCorners], color: UIColor.white)
        bar.layer.shadowColor = UIColor.black.cgColor
        bar.layer.shadowOffset = CGSize(width: 0, height: 3)
        bar.layer.shadowRadius = 5
        bar.layer.shadowOpacity = 0.25
        
        return bar
    }
    
    func setupConstraints() {
        storedConstraintValue = searchBarTopConstraint.constant
        collectionViewLeftConstraint.constant += citiesCollectionView.frame.width / 2
        self.superview?.layoutIfNeeded()
    }
    
    func setupCollectionView() {
        let cityCellNib = UINib(nibName: DestinationCollectionCell.nibName, bundle: nil)
        citiesCollectionView.register(cityCellNib, forCellWithReuseIdentifier: DestinationCollectionCell.reuseIdentifier)
    }
    
    func defaultSearchBarConfig(_ rasterSize: CGFloat) -> SHSearchBarConfig {
        var config: SHSearchBarConfig = SHSearchBarConfig()
        config.rasterSize = rasterSize
        config.cancelButtonTextAttributes = [.foregroundColor: UIColor.white]
        config.textContentType = UITextContentType.fullStreetAddress.rawValue
        config.textAttributes = [.foregroundColor: UIColor.gray]
        return config
    }
    
    func searchBarDidBeginEditing(_ searchBar: SHSearchBar) {
        if viewModel.searchBarState.value == .down {
            citiesCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
            viewModel.currentCityIndexPath.value?.row = 0
            
            searchBarToTextConstraint?.isActive = false
            searchBarTopConstraint.constant = 50
            
            collectionViewLeftConstraint.constant -= citiesCollectionView.frame.width / 2
            UIView.animate(withDuration: 0.4, animations: {
                self.helloTextLabel.alpha = 0
            })
            UIView.animate(withDuration: 0.4, delay: 0.3, animations: {
                self.superview?.layoutIfNeeded()
                self.citiesCollectionView.alpha = 1
                self.popularDestinationsLabel.alpha = 1
            })
            
            viewModel.searchBarState.value = .up
        }
    }
    
    func searchBarShouldCancel(_ searchBar: SHSearchBar) -> Bool {
        if viewModel.searchBarState.value! == .up {
            searchBarTopConstraint.constant = storedConstraintValue!
            collectionViewLeftConstraint.constant += citiesCollectionView.frame.width / 2
            UIView.animate(withDuration: 0.4, delay: 0.3, animations: {
                self.helloTextLabel.alpha = 1
            })
           
            UIView.animate(withDuration: 0.4, animations: {
                self.superview?.layoutIfNeeded()
                self.citiesCollectionView.alpha = 0
                self.popularDestinationsLabel.alpha = 0
            }, completion: { result in
                self.searchBarToTextConstraint?.isActive = true
            })
            viewModel.searchBarState.value = .down
        }
        return true
    }
}

extension DestinationSearchView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.topCities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DestinationCollectionCell.reuseIdentifier, for: indexPath) as! DestinationCollectionCell
        let cityName = viewModel.topCities[indexPath.row]
        let image = UIImage(named: cityName)!
        cell.configureCell(image: image, text: cityName)
        
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true

//        cell.layer.shadowOffset = CGSize(width:0, height:1.0)
//        cell.layer.shadowColor = UIColor.black.cgColor
//        cell.layer.shadowOpacity = 0.3
//        cell.layer.shadowRadius = 5
//        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.frame, cornerRadius: 20).cgPath
        
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if (translation.x < 0) {
            if viewModel.currentCityIndexPath.value!.row < viewModel.topCities.count - 1 {
                viewModel.currentCityIndexPath.value!.row += 1
            }
        } else {
            if viewModel.currentCityIndexPath.value!.row != 0 {
                viewModel.currentCityIndexPath.value!.row -= 1
            }
        }
        citiesCollectionView.scrollToItem(at: viewModel.currentCityIndexPath.value!, at: .centeredHorizontally, animated: true)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        citiesCollectionView.scrollToItem(at: viewModel.currentCityIndexPath.value!, at: .centeredHorizontally, animated: true)
    }
    
}

extension DestinationSearchView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                    sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 350, height: 350)
    }
}
