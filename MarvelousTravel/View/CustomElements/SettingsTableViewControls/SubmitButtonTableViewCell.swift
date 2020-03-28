//
//  SubmitButtonTableViewCell.swift
//  MarvelousTravel
//
//  Created by  Ilia Goncharenko on 2020-03-26.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit

class SubmitButtonTableViewCell: UITableViewCell {
    
    var submitButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 15.0
        button.layer.borderWidth = 1.0
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupSubview()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupSubview() {
        self.addSubview(submitButton)
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0), submitButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0), self.trailingAnchor.constraint(equalTo: submitButton.trailingAnchor, constant: 20.0),  self.bottomAnchor.constraint(equalTo: self.submitButton.bottomAnchor, constant: 5.0)
        ])
        
    }

}
