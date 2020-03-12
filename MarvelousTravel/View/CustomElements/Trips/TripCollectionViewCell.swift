//
//  TripCollectionViewCell.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/10/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit
import expanding_collection
import SDWebImage

class TripCollectionViewCell: BasePageCollectionCell {
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var customTitle: UILabel!
    @IBOutlet weak var flagsCollectionView: UICollectionView!
    @IBOutlet weak var pirticipantsIconStackView: UIStackView!
    @IBOutlet weak var tripDurationLabel: UILabel!
    
    var cities = [City]()
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        customTitle.layer.shadowRadius = 2
        customTitle.layer.shadowOffset = CGSize(width: 0, height: 3)
        customTitle.layer.shadowOpacity = 0.2
    }
    
    func configureCell(tripData: Trip) {
        cities = tripData.destinations.map({($0.city!)})
        setBackgroundImage()
    }
    
    func setBackgroundImage() {
        let cityImages = cities.first?.getImagesUrl(size: .medium)
        if cityImages != nil {
            let randomUrlIndex = Int.random(in: 1..<cityImages!.count)
            if cityImages![randomUrlIndex] != nil {
                let imageUrl = URL(string: cityImages![randomUrlIndex]!)!
                backgroundImageView.sd_setImage(with: imageUrl)
            }
        }
    }
    
    class var reuseIdentifier: String {
        return "TripCellIdentifier"
    }
    
    class var nibName: String {
        return "TripCollectionViewCell"
    }

}
