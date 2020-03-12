//
//  CityPOIController.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/3/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit

protocol CategoryRowDelegate: class {
    func cellTapped(cellIndex: Int)
}

class CityPOIController: UIViewController, CategoryRowDelegate {
        
    @IBOutlet weak var transitionButton: UIButton!
    @IBOutlet weak var poiOverviewCollectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    let viewModel = CityPOIViewModel()
    
    // flags
    var isPoiCollectionLoaded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        initialSetup()
        
        transitionButton.addTarget(self, action: #selector (transitionRequested), for: .touchUpInside)

        self.observe(for: viewModel.categorySelected) {
            newValue in
            self.viewModel.loadPoiOverviewDataForSelectedCategory(label: newValue, onCompletion: {
                isUpdateRequired in
                if isUpdateRequired {
                    DispatchQueue.main.async {
                        self.refreshPoiCollectionView()
                    }
                }
            })
        }
    }
    
    func initialSetup() {
//        poiOverviewCollectionView.isHidden = true
        let initialCategorySelected = viewModel.categories[0]
        viewModel.categorySelected.value = initialCategorySelected
        categoriesCollectionView.selectItem(at: IndexPath(row:0, section:0), animated: false, scrollPosition: .left)
        
        self.viewModel.loadPoiOverviewDataForSelectedCategory(label: initialCategorySelected, onCompletion: {
            isUpdateRequired in
            if isUpdateRequired {
                DispatchQueue.main.async {
                    self.refreshPoiCollectionView()
                    self.isPoiCollectionLoaded = true
//                    self.poiOverviewCollectionView.isHidden = false
//                    self.poiOverviewCollectionView.reloadSections(IndexSet(arrayLiteral: 0))

                }
            }
        })
    }
    
    func refreshPoiCollectionView() {
        var indexPathArray = [IndexPath]()
        for i in 0..<viewModel.numberOfElementsToShow {
            indexPathArray.append(IndexPath(row: i, section: 0))
        }
        self.poiOverviewCollectionView.performBatchUpdates({
            self.poiOverviewCollectionView.deleteItems(at: indexPathArray)
            self.poiOverviewCollectionView.insertItems(at:indexPathArray)
        }, completion: nil)
    }
    
    func registerNib() {
        // register nib for categories collection view
        let categoriesNib = UINib(nibName: CategoryCollectionViewCell.nibName, bundle: nil)
        categoriesCollectionView?.register(categoriesNib, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
        if let flowLayout = self.categoriesCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        // register nib for poi overview collection view
        let poiNib = UINib(nibName: PoiOverviewCollectionViewCell.nibName, bundle: nil)
        poiOverviewCollectionView?.register(poiNib, forCellWithReuseIdentifier: PoiOverviewCollectionViewCell.reuseIdentifier)
        if let flowLayout = self.poiOverviewCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
    }
   
    
    func cellTapped(cellIndex: Int) {
//        poiOverviewCollectionView.isHidden = false
        if viewModel.categorySelected.value != viewModel.categories[cellIndex] {
            viewModel.categorySelected.value = viewModel.categories[cellIndex]
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CityPOIDetailedTransition" {
            if let nextViewController = segue.destination as? CityPOIDetailedViewController {
                let previousVewController = segue.source as! CityPOIController
                let categorySelected = previousVewController.viewModel.categorySelected.value
                let selectedPoiData = previousVewController.viewModel.categoryData[categorySelected!]
                
                nextViewController.viewModel.poiData = selectedPoiData!.poiData
                nextViewController.viewModel.label = selectedPoiData!.label
                nextViewController.viewModel.locationId = previousVewController.viewModel.locationId.value!
            }
        }
    }
    
    @objc func transitionRequested(sender: UIButton) {
        performSegue(withIdentifier: "CityPOIDetailedTransition", sender: nil)
    }
}

extension CityPOIController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.categoriesCollectionView {
            return viewModel.categories.count
        } else {
            return viewModel.numberOfElementsToShow
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.categoriesCollectionView {
            return configureCetegoriesCollectionCell(collectionView, cellForItemAt: indexPath)
        } else {
            return configurePoiOverviewCollectionCell(collectionView, cellForItemAt: indexPath)
        }
    }
    
    func configureCetegoriesCollectionCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier, for: indexPath) as? CategoryCollectionViewCell {
            let name = viewModel.categories[indexPath.row]
            cell.configureCell(name: name)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func configurePoiOverviewCollectionCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PoiOverviewCollectionViewCell.reuseIdentifier, for: indexPath) as? PoiOverviewCollectionViewCell {
            let selectedCategory = viewModel.categorySelected.value
            let categoryData = viewModel.categoryData[selectedCategory!]
            let status = categoryData?.isLoaded
            if status! {
                let poiData = categoryData!.poiData[indexPath.row]
                cell.configureCell(poi: poiData)
            }
            return cell
        }
        return UICollectionViewCell()
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.categoriesCollectionView {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            cellTapped(cellIndex: indexPath.row)
        }
    }
}

extension CityPOIController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.categoriesCollectionView {
            return configureCategoriesCellLayout(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
        } else {
            return configurePoiOverviewCellLayout(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
        }
    }
    
    
    func configureCategoriesCellLayout(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell: CategoryCollectionViewCell = Bundle.main.loadNibNamed(CategoryCollectionViewCell.nibName,
                                     owner: self,
                                     options: nil)?.first as? CategoryCollectionViewCell else {
            return CGSize.zero
        }
        cell.configureCell(name: viewModel.categories[indexPath.row])
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: size.width, height: 30)
    }
    
    func configurePoiOverviewCellLayout(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell: PoiOverviewCollectionViewCell = Bundle.main.loadNibNamed(PoiOverviewCollectionViewCell.nibName,
                                     owner: self,
                                     options: nil)?.first as? PoiOverviewCollectionViewCell else {
            return CGSize.zero
        }
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: size.width, height: 320)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // TODO this affects collection view when it reloads. Rework it
        if isPoiCollectionLoaded {
            if collectionView != self.categoriesCollectionView {
                UIView.animate(withDuration: 2, animations: {
                    let newFrame = cell.frame
                    cell.frame = CGRect(x: newFrame.origin.x + 100, y: newFrame.origin.y, width: newFrame.width, height: newFrame.height)
                })
            }
        }
    }
}

