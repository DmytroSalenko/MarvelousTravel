//
//  UIImageExtension.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/5/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation
import UIKit

//extension UIImageView {
//    func load(url: URL) {
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
//    
//    private var activityIndicator: UIActivityIndicatorView {
//        let activityIndicator = UIActivityIndicatorView()
//        activityIndicator.hidesWhenStopped = true
//        activityIndicator.color = UIColor.black
//        self.addSubview(activityIndicator)
//
//        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//
//        let centerX = NSLayoutConstraint(item: self,
//                                         attribute: .centerX,
//                                         relatedBy: .equal,
//                                         toItem: activityIndicator,
//                                         attribute: .centerX,
//                                         multiplier: 1,
//                                         constant: 0)
//        let centerY = NSLayoutConstraint(item: self,
//                                         attribute: .centerY,
//                                         relatedBy: .equal,
//                                         toItem: activityIndicator,
//                                         attribute: .centerY,
//                                         multiplier: 1,
//                                         constant: 0)
//        self.addConstraints([centerX, centerY])
//        return activityIndicator
//    }
//}
//
//extension UIImage {
//    convenience init?(withContentsOfUrl url: URL) throws {
//        let imageData = try Data(contentsOf: url)
//    
//        self.init(data: imageData)
//    }
//
//}
