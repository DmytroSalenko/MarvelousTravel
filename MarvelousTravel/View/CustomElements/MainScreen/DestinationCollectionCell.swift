//
//  DestinationCollectionCell.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/25/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit

class DestinationCollectionCell: UICollectionViewCell {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
    }
    
    func configureCell(image: UIImage, text: String) {
        imageView.image = image
        cityNameLabel.text = text
    }
    
    class var reuseIdentifier: String {
        return "destinationTopCell"
    }
    
    class var nibName: String {
        return "DestinationCollectionCell"
    }

}
