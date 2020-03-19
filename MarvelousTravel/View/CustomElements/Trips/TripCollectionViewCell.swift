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
    @IBOutlet weak var darkOverlayView: UIView!
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var customTitle: UILabel!
    @IBOutlet weak var pirticipantsIconStackView: UIStackView!
    @IBOutlet weak var tripDurationLabel: UILabel!
    @IBOutlet weak var tripCreatorImage: UIImageView!
    @IBOutlet weak var citiesNumberLabel: UILabel!
    @IBOutlet weak var tripDescriptionLabel: UILabel!
    
    var isParticipantsShown = false
    
    var cities = [City]()
    var tripData: Trip?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        customTitle.layer.shadowRadius = 2
        customTitle.layer.shadowOffset = CGSize(width: 0, height: 3)
        customTitle.layer.shadowOpacity = 0.2
        
        tripCreatorImage.layer.cornerRadius = tripCreatorImage.frame.width / 2
        tripCreatorImage.layer.masksToBounds = true
        
        pirticipantsIconStackView.translatesAutoresizingMaskIntoConstraints = false
        pirticipantsIconStackView.distribution = .fill
        pirticipantsIconStackView.spacing = -15
        let touchRecognizer = UITapGestureRecognizer(target: self, action: #selector(showParticipants))
        pirticipantsIconStackView.addGestureRecognizer(touchRecognizer)
        //        darkOverlayView.applyGradient()
    }
    
    func configureCell(tripData: Trip, stockImageUrl: String?) {
        // save dataModel
        self.tripData = tripData
        self.cities = tripData.destinations.map({($0.city!)})
        
        // set trip title and number of citites
        customTitle.text = self.tripData?.name
        citiesNumberLabel.text = "\(cities.count) \(cities.count == 1 ? "city" : "cities")"
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.date(from: (self.tripData?.destinations.first!.startDate)!)
        let endDate = dateFormatter.date(from: (self.tripData?.destinations.last!.endDate)!)
        let tripDuration = DateInterval(start: startDate!, end: endDate!)
        let durationInDays = Int(tripDuration.duration / 3600 / 24)
        tripDurationLabel.text = "\(durationInDays) \(durationInDays == 1 ? "day" : "days")"
        
        tripDescriptionLabel.text = self.tripData?.description
        
        setCreatorImage()
        setParticipantsImages()
        // set trip background image
        if stockImageUrl != nil {
            setBackgroundImageFromStock(imageUrlString: stockImageUrl!)
        } else {
            setBackgroundImageFromTrip()
        }
    }
    
    func setCreatorImage() {
        let creatorData = self.tripData?.creator
        var iconUrl = creatorData?.mini_icon_path
        if iconUrl != nil {
            iconUrl = iconUrl!
            tripCreatorImage.sd_setImage(with: URL(string:iconUrl!)!)
        }
    }
    
    func setBackgroundImageFromTrip() {
        let cityImages = cities.first?.getImagesUrl(size: .medium)
        if cityImages != nil {
            let randomUrlIndex = Int.random(in: 1..<cityImages!.count)
            if cityImages![randomUrlIndex] != nil {
                let imageUrl = URL(string: cityImages![randomUrlIndex]!)!
            
                backgroundImageView.sd_setImage(with: imageUrl)
            }
        }
    }
    
    func setBackgroundImageFromStock(imageUrlString: String) {
        let imageUrl = URL(string: imageUrlString)!
        backgroundImageView.sd_setImage(with: imageUrl)
    }
    
    func setParticipantsImages() {
        guard let participants = tripData!.participants else { return }
        for participant in participants {
            let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            NSLayoutConstraint(item: image, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: image.frame.width).isActive = true
            NSLayoutConstraint(item: image, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: image.frame.height).isActive = true

            image.layer.cornerRadius = image.frame.width / 2
            image.layer.masksToBounds = true
            image.backgroundColor = .brown
            
            if let participantIconPath = participant.mini_icon_path {
                image.sd_setImage(with: URL(string: participantIconPath)!)
            }
            
            pirticipantsIconStackView.addArrangedSubview(image)
        }
        let stratcherView = UIView()
        stratcherView.backgroundColor = .clear
        pirticipantsIconStackView.addArrangedSubview(stratcherView)
    }
    
    @objc func showParticipants() {
        if !isParticipantsShown {
            UIView.animate(withDuration: 0.5, animations: {
                self.pirticipantsIconStackView.spacing = 10
            })
            isParticipantsShown = true
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.pirticipantsIconStackView.spacing = -15
            })
            isParticipantsShown = false
        }
    }
    
    override func prepareForReuse() {
        citiesNumberLabel.text = ""
        tripDurationLabel.text = ""
        customTitle.text = ""
        pirticipantsIconStackView.removeAllArrangedSubviews()
    }
    
    class var reuseIdentifier: String {
        return "TripCellIdentifier"
    }
    
    class var nibName: String {
        return "TripCollectionViewCell"
    }
}


extension UIStackView {
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
               self.removeArrangedSubview(subview)
               return allSubviews + [subview]
        }
        
       // Remove the views from self
       removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
