//
//  CalendarView.swift
//  MarvelousTravel
//
//  Created by  Ilia Goncharenko on 2020-03-06.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit
import Koyomi

@IBDesignable
class CalendarView: UIView, KoyomiDelegate {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var koyomiCalendar: Koyomi!
    @IBOutlet weak var doneButton: UIButton!
    // optional tuple for start and end date
    var destinationDate : (Date?, Date?)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
        koyomiCalendar.calendarDelegate = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        koyomiCalendar.calendarDelegate = self
    }
    
    @IBAction func doneButtonOnTouch(_ sender: UIButton) {
        //guard let destinationDates = destinationDate else {return}
        NotificationCenter.default.post(name: NSNotification.Name("dismissCalendarNotification"), object: destinationDate)
    }
    
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "y/MMMM/d"
        
        if segmentControl.selectedSegmentIndex == 0 {
            koyomiCalendar.display(in: .current)
            dateLabel.text = "Date: \(formatter.string(from: currentDate))"
        } else if segmentControl.selectedSegmentIndex == 1 {
            koyomiCalendar.display(in: .next)
            let monthToAdd = 1
            var dateComponent = DateComponents()
            dateComponent.month = monthToAdd
            let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
            dateLabel.text = "Date: \(formatter.string(from: futureDate!))"
        }
    }
    
    func setupSubviews() {
        let nib = UINib(nibName: "CalendarView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        // set corner radious to view
        contentView.layer.cornerRadius = contentView.bounds.width / 20
        koyomiCalendar.selectionMode = .sequence(style: .circle)
        addSubview(contentView)
        doneButton.isEnabled = false
        
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "y/MMMM/d"
        dateLabel.text = "Date: \(formatter.string(from: currentDate))"
    }
    
    func koyomi(_ koyomi: Koyomi, shouldSelectDates date: Date?, to toDate: Date?, withPeriodLength length: Int) -> Bool {
        destinationDate = (date, toDate)
        doneButton.isEnabled = true
        return true
    }
    
}
