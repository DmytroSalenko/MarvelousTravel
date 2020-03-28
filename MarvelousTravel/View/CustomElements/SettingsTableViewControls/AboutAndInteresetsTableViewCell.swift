//
//  AbboutTableViewCell.swift
//  MarvelousTravel
//
//  Created by  Ilia Goncharenko on 2020-03-26.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit

class AboutAndInteresetsTableViewCell: UITableViewCell {
    
    let textView : UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 18.0)
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 10.0
        textView.isScrollEnabled = false
        return textView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupUI() {
        self.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0), textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0), self.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 20.0), self.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: 5.0)
        ])
    }

}
