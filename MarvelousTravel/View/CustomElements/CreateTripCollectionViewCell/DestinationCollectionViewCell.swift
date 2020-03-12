//
//  DestinationCollectionViewCell.swift
//  MarvelousTravel
//
//  Created by  Ilia Goncharenko on 2020-03-10.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit

class DestinationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var endDate: UILabel!
    
    func displayContent(country : String, city : String, startDate  :String, endDate : String) {
        self.countryNameLabel.text = "Country: \(country)"
        self.cityNameLabel.text = "City: \(city)"
        self.startDate.text = "Start date: \(startDate)"
        self.endDate.text = "End date: \(endDate)"
    }
    
}
