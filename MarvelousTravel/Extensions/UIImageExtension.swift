//
//  UIImageExtension.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/5/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    func applyGradientColor(locations: [NSNumber], colors: [CGColor]) {
        var gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors //[UIColor.white.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = locations //[0.0, 0.5]
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func applyGradientMask(locations: [NSNumber], colors: [CGColor]) {
        var gradientMaskLayer:CAGradientLayer = CAGradientLayer()
        gradientMaskLayer.frame = self.bounds
        gradientMaskLayer.colors = colors //[UIColor.white.cgColor, UIColor.black.cgColor]
        gradientMaskLayer.locations = locations //[0.0, 0.5]
        self.layer.mask = gradientMaskLayer
    }
}

