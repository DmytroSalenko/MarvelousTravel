//
//  TripListViewController.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/10/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit
import expanding_collection
import Foundation

internal func Init<Type>(_ value: Type, block: (_ object: Type) -> Void) -> Type {
    block(value)
    return value
}

class TripListViewController: ExpandingViewController {
    fileprivate var cellsIsOpen = [Bool]()
    @IBOutlet var pageLabel: UILabel!
    
    let viewModel = TripCollectionViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadTrips(completionHandler: {
            status in
            if status {
                self.fillCellIsOpenArray()
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        })
        itemSize = CGSize(width: 260, height: 350) //IMPORTANT!!! Height of open state cell

        registerNib()
        addGesture(to: collectionView!)
    }

    func registerNib() {
        // register cell
        let nib = UINib(nibName: TripCollectionViewCell.nibName, bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: TripCollectionViewCell.reuseIdentifier)
    }

    fileprivate func fillCellIsOpenArray() {
        cellsIsOpen = Array(repeating: false, count: viewModel.tripArray.count)
    }

    fileprivate func getViewController() -> ExpandingTableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toViewController: TripTableViewController = storyboard.instantiateViewController(identifier: "TripTableViewController")
        return toViewController
    }
}

extension TripListViewController {

    fileprivate func addGesture(to view: UIView) {
        let upGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(TripListViewController.swipeHandler(_:)))) {
            $0.direction = .up
        }

        let downGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(TripListViewController.swipeHandler(_:)))) {
            $0.direction = .down
        }
        view.addGestureRecognizer(upGesture)
        view.addGestureRecognizer(downGesture)
    }

    @objc func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        let indexPath = IndexPath(row: currentIndex, section: 0)
        guard let cell = collectionView?.cellForItem(at: indexPath) as? TripCollectionViewCell else { return }
        // double swipe Up transition
        if cell.isOpened == true && sender.direction == .up {
            pushToViewController(getViewController())

//            if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
//                rightButton.animationSelected(true)
//            }
        }

        let open = sender.direction == .up ? true : false
        cell.cellIsOpen(open)
        cellsIsOpen[indexPath.row] = cell.isOpened
    }
}

extension TripListViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tripArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TripCollectionViewCell, currentIndex == indexPath.row else { return }

        if cell.isOpened == false {
            cell.cellIsOpen(true)

        } else {
            pushToViewController(getViewController())

//            if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
//                rightButton.animationSelected(true)
//            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TripCollectionViewCell.reuseIdentifier, for: indexPath) as? TripCollectionViewCell {
            let trip = viewModel.tripArray[indexPath.row]
            let stockImageUrl = viewModel.stockPhotoArray[indexPath.row]
            cell.configureCell(tripData: trip, stockImageUrl: stockImageUrl)
            return cell
        }
        return UICollectionViewCell()
    }
}


