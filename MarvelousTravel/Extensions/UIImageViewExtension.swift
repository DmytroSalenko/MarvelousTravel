//
//  UIImageViewExtension.swift
//  MarvelousTravel
//
//  Created by  Ilia Goncharenko on 2020-03-21.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImageAndSetWithBrightness(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self!.setBrightness(image: image)
                    }
                }
            }
        }
    }
    
    func setBrightness(image : UIImage) {
        // changing brightness
        let imageCG = image.cgImage
        let aCIImage = CIImage(cgImage: imageCG!)
        let context = CIContext(options: nil)
        var brightnessFilter = CIFilter(name: "CIColorControls")
        brightnessFilter?.setValue(aCIImage, forKey: "inputImage")
        brightnessFilter?.setValue(0.3, forKey: "inputBrightness")
        let outputImage = brightnessFilter?.outputImage!
        let cgimg = context.createCGImage(outputImage!, from: outputImage!.extent)
        let newUIImage = UIImage(cgImage: cgimg!)
        self.image = newUIImage
    }
}
