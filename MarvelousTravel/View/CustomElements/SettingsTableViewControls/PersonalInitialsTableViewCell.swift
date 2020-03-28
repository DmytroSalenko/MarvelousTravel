//
//  PersonalInitialsTableViewCell.swift
//  MarvelousTravel
//
//  Created by  Ilia Goncharenko on 2020-03-26.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit

class PersonalInitialsTableViewCell: UITableViewCell {
    
    var infoTextField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = textField.font?.withSize(20.0)
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 10.0
        return textField
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        self.addSubview(infoTextField)
        
        NSLayoutConstraint.activate([
            infoTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0), infoTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0), self.trailingAnchor.constraint(equalTo: infoTextField.trailingAnchor, constant: 20.0),  self.bottomAnchor.constraint(equalTo: self.infoTextField.bottomAnchor, constant: 5.0)
        ])
    }

}
