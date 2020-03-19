//
//  DemoElongationCell.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 09/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import ElongationPreview
import UIKit
import SDWebImage

final class DemoElongationCell: ElongationCell {
    
    var dataSource: CityWalkWaypoint?

    @IBOutlet var topImageView: UIImageView!
    @IBOutlet var poiLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!

    @IBOutlet var aboutTitleLabel: UILabel!
    @IBOutlet var aboutDescriptionLabel: UILabel!

    @IBOutlet var topImageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var numberLabel: UILabel!
    
    class var reuseIdentifier: String {
        return "demoElongationCell"
    }
    
    class var nibName: String {
        return "DemoElongationCell"
    }
    
    func configureCell() {
        guard let cityPoi = dataSource?.poi else { return }
        let attributedPoiName = NSMutableAttributedString(string: cityPoi.name!.uppercased(), attributes: [
        //            NSAttributedString.Key.font: UIFont.robotoFont(ofSize: 22, weight: .medium),
                    NSAttributedString.Key.kern: 8.2,
                    NSAttributedString.Key.foregroundColor: UIColor.white,
                ])
        poiLabel?.attributedText = attributedPoiName
        cityLabel.text = cityPoi.location_id
        aboutTitleLabel.text = cityPoi.name
        aboutDescriptionLabel.text = cityPoi.snippet
        
        if let imageUrlString = cityPoi.images?.first?.sizes?.medium?.url {
            topImageView.sd_imageTransition = .fade
            topImageView.sd_setImage(with: URL(string: imageUrlString)!)
        }
        
//        numberLabel.layer.borderColor = UIColor.white.cgColor
//        numberLabel.layer.borderWidth = 1
//        numberLabel.layer.cornerRadius = numberLabel.frame.width / 2
    }
    
    func swipeMade(_ sender: UISwipeGestureRecognizer) {
       if sender.direction == .up {
          print("up swipe made")
          // perform actions here.
       }
    }
}
