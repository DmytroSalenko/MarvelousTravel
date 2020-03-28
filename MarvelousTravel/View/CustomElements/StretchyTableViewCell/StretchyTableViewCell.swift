//
//  StretchyTableViewCell.swift
//  MarvelousTravel
//
//  Created by  Ilia Goncharenko on 2020-03-25.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit

class StretchyTableViewCell: UITableViewCell {
    
    var imageComment : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "swift")
        image.layer.cornerRadius = 22.0
        image.clipsToBounds = true
        return image
    }()
    
    var commentLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    var fullNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = "Eddie Merphie"
        return label
    }()
    
    var dateLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = label.font.withSize(12)
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        label.text = dateFormatter.string(from: date)
        return label
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
        self.addSubview(commentLabel)
        self.addSubview(imageComment)
        self.addSubview(fullNameLabel)
        self.addSubview(dateLabel)
        
        imageComment.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0).isActive = true
        imageComment.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0).isActive = true
        imageComment.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        imageComment.widthAnchor.constraint(equalToConstant: 45.0).isActive = true
        
        commentLabel.topAnchor.constraint(equalTo: imageComment.bottomAnchor, constant: 5.0).isActive = true
        commentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        commentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        self.trailingAnchor.constraint(equalTo: commentLabel.trailingAnchor, constant: 20).isActive = true
        
        fullNameLabel.leadingAnchor.constraint(equalTo: imageComment.trailingAnchor, constant: 10.0).isActive = true
        fullNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 13.0).isActive = true
        fullNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -100.0).isActive = true
        
        dateLabel.leadingAnchor.constraint(equalTo: imageComment.trailingAnchor, constant: 10.0).isActive = true
        dateLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 3.0).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -100.0).isActive = true
    }

}



//commentLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//commentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//commentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 80).isActive = true
//self.trailingAnchor.constraint(equalTo: commentLabel.trailingAnchor, constant: 20).isActive = true
//
//imageComment.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0).isActive = true
//imageComment.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
//commentLabel.leadingAnchor.constraint(equalTo: imageComment.trailingAnchor, constant: 20.0).isActive = true
//imageComment.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
