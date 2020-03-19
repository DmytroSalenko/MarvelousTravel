//
//  CityWalkTimingCell.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/17/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit

class CityWalkTimingCell: UITableViewCell {

    @IBOutlet weak var durationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDurationText(duration: Int) {
        durationLabel.text = "\(duration) minutes walk"
    }
    
    class var reuseIdentifier: String {
        return "timingCell"
    }
    
    class var nibName: String {
        return "CityWalkTimingCell"
    }
    
}
