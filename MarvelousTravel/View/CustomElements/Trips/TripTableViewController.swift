//
//  TripTableViewController.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/10/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit
import expanding_collection

class TripTableViewController: ExpandingTableViewController {

    fileprivate var scrollOffsetY: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
//        configureNavBar()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
    }
}

// MARK: Helpers

//extension TripTableViewController {
//
//    fileprivate func configureNavBar() {
//        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        navigationItem.rightBarButtonItem?.image = navigationItem.rightBarButtonItem?.image!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//    }
//}

// MARK: Actions

//extension TripTableViewController {
//
//    @IBAction func backButtonHandler(_: AnyObject) {
        // buttonAnimation
//        let viewControllers: [DemoViewController?] = navigationController?.viewControllers.map { $0 as? DemoViewController } ?? []

//        for viewController in viewControllers {
//            if let rightButton = viewController?.navigationItem.rightBarButtonItem as? AnimatingBarButton {
//                rightButton.animationSelected(false)
//            }
 //       }
//        popTransitionAnimation()
//    }
//}

// MARK: UIScrollViewDelegate

//extension TripTableViewController {
//
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y < -25 , let navigationController = navigationController {
//            // buttonAnimation
//            for case let viewController as DemoViewController in navigationController.viewControllers {
//                if case let rightButton as AnimatingBarButton = viewController.navigationItem.rightBarButtonItem {
//                    rightButton.animationSelected(false)
//                }
//            }
//            popTransitionAnimation()
//        }
//        scrollOffsetY = scrollView.contentOffset.y
//    }
//}
