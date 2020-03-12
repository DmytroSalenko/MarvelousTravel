//
//  CityPoiImageCell.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/7/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit
import SDWebImage

class CityPoiImageCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class var reuseIdentifier: String {
        return "CityPoiImageCellIdentifier"
    }
    
    class var nibName: String {
        return "CityPoiImageCell"
    }
    
    func configureCell(imageUrl: URL) {
        imageView.sd_imageTransition = .fade
        imageView.sd_setImage(with: imageUrl)
    }
}
