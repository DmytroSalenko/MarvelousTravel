//
//  PoiOverviewCollectionViewCell.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/4/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit
import SDWebImage

class PoiOverviewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var poiLikeButton: UIButton!
    @IBOutlet weak var poiImage: UIImageView!
    @IBOutlet weak var poiNameLabel: UILabel!
    
    func configureCell(poi: CityPoi) {
        self.poiNameLabel.text = poi.name
        self.poiNameLabel.numberOfLines = 0
        self.poiNameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.poiNameLabel.sizeToFit()
        self.poiNameLabel.adjustsFontSizeToFitWidth = true
        // load image asynchronously with animation
        let imageUrl =  URL(string: poi.images![0].sizes!.thumbnail!.url!)!
        self.poiImage.sd_imageTransition = .fade
        self.poiImage.sd_setImage(with: imageUrl)
    }
    
    class var reuseIdentifier: String {
        return "PoiOverviewCollectionViewCellIdentifier"
    }

    class var nibName: String {
        return "PoiOverviewCollectionViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //hide or reset anything you want hereafter, for example
        poiImage.image = nil

    }

}
