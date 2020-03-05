//
//  CategoryCollectionViewCell.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/4/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryNameLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                categoryNameLabel.textColor = .red
            } else {
                categoryNameLabel.textColor = .black
            }
        }
    }
    
    class var reuseIdentifier: String {
        return "CategoryCollectionViewCellIdentifier"
    }

    class var nibName: String {
        return "CategoryCollectionViewCell"
    }
    
    func configureCell(name: String) {
        self.categoryNameLabel.text = name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}


