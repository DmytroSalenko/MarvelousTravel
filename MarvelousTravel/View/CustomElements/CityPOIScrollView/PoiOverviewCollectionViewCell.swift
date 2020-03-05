//
//  PoiOverviewCollectionViewCell.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/4/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit

class PoiOverviewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var poiLikeButton: UIButton!
    @IBOutlet weak var poiImage: UIImageView!
    @IBOutlet weak var poiNameLabel: UILabel!
    
    func configureCell(name: String) {
        self.poiNameLabel.text = name
        self.poiNameLabel.numberOfLines = 0
        self.poiNameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.poiNameLabel.sizeToFit()
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
    

}
