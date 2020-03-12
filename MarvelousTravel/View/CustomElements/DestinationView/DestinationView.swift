//
//  DestinationView.swift
//  MarvelousTravel
//
//  Created by  Ilia Goncharenko on 2020-03-02.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation
import BFWControls
import UIKit

class DestinationView : UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var selectDateButton: UIButton!
    
    var tableView = UITableView()
    var calendarView : CalendarView?
    
    var selectedCity : String? {
        get {
            return cityTextField.text
        }
    }
    
    var padding : CGFloat = 20 {
        didSet {
            setNeedsLayout()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
        calendarView = CalendarView(frame: contentView.frame)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        calendarView = CalendarView(frame: contentView.frame)
    }
    
    func setupSubviews() {
        let nib = UINib(nibName: "DestinationView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        setupTableView()
        // set corner radious to view
        contentView.layer.cornerRadius = contentView.bounds.width / 20
    }
    
    func setupTableView() {
        tableView = UITableView(frame: CGRect(x: padding, y: cityTextField.frame.maxY + 10, width: 315, height: 130), style: .plain)
        addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.clipsToBounds = true
    }
    
    
    @IBAction func selectDateButtonOnTouch(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("switchViewNotification"), object: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}
