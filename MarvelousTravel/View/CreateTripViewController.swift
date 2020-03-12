//
//  CreateTripViewController.swift
//  MarvelousTravel
//
//  Created by  Ilia Goncharenko on 2020-03-03.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit
import Koyomi

class CreateTripViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UITextViewDelegate {
    @IBOutlet weak var destinationsCollectionView: UICollectionView!
    @IBOutlet weak var addDestinationButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var createTripButton: UIButton!
    var trip = Trip()
    var destinationView : DestinationView?
    var calendarView : CalendarView?
    let cityService = CitiesService(config: URLSessionConfiguration.default)
    var autoCompletePossibilities = [City]()
    var autoComplete = [City]()
    let tripService = TripService()
    var selectedCity : City?
    var destinationDate : (Date?, Date?)
    var destinationsArray = [Any]()
    var doesTextFieldHaveValue = false
    var frame = CGRect.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleSwitchViewNotification(notification:)), name: NSNotification.Name(rawValue: "switchViewNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDismissViewNotification(notification:)), name: NSNotification.Name(rawValue: "dismissCalendarNotification"), object: nil)
        // destination
        destinationView = DestinationView(frame: CGRect(x: 10, y: 250, width: self.view.bounds.width - 20, height: self.view.bounds.height / 2.5))
        // setup dependencies
        destinationsCollectionView.dataSource = self
        destinationsCollectionView.delegate = self
        destinationView?.tableView.delegate = self
        destinationView?.tableView.dataSource = self
        destinationView?.cityTextField.delegate = self
        destinationView?.tableView.isHidden = true
        destinationsCollectionView.isHidden = true
        tripNameTextField.addTarget(self, action: #selector(fieldDidChange), for: .editingChanged)
        descriptionTextView.delegate = self
        createTripButton.isEnabled = false
    }
    
    @objc func fieldDidChange() {
        guard let name = tripNameTextField.text, name != "" else {
        errorHighlightTextField()
        createTripButton.isEnabled = false
        doesTextFieldHaveValue = false
        return
        }
        removeErrorHighlight()
        doesTextFieldHaveValue = true
    }
    
    @objc func handleDismissViewNotification(notification : NSNotification) {
        // receive dates
        destinationDate = notification.object as! (Date?, Date?)
        removeWithZoomOutAnimation(customView: calendarView)
        calendarView = nil
        addDestinationRepresentationView()
    }
    
    @objc func handleSwitchViewNotification(notification : NSNotification) {
        // receive selected city
        let cityName = destinationView?.selectedCity
        // change view
        removeWithZoomOutAnimation(customView: destinationView)
        addSubviewWithZoomInAnimation(customView: calendarView)
    }
    
    @IBAction func addDestinationButtonOnTouch(_ sender: UIButton) {
        // add calendar view
        calendarView = CalendarView(frame: CGRect(x: 10, y: 250, width: self.view.bounds.width - 20, height: self.view.bounds.height / 2.5))
        // do preparation before showing views
        destinationView?.selectDateButton.isEnabled = false
        destinationView?.cityTextField.text = ""
        addSubviewWithZoomInAnimation(customView: destinationView)
    }
    
    
    @IBAction func createTripButtonOnTouch(_ sender: UIButton) {
        createTrip()
    }
    
    func addSubviewWithZoomInAnimation(customView : UIView?) {
        
        customView!.transform = self.view.transform.scaledBy(x: 0.01, y: 0.01)
        view.addSubview(customView!)
        UIView.transition(with: customView!, duration: 0.7, options: .transitionCrossDissolve, animations: {
            customView!.transform = CGAffineTransform.identity
            
        }, completion: nil)
    }
    
    func removeWithZoomOutAnimation(customView : UIView?) {
        UIView.animate(withDuration: 0.7, delay: 0.0, options: [.curveEaseInOut], animations: {
            customView?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }) { (isFinished) in
            customView?.transform = CGAffineTransform(scaleX: 0, y: 0)
            customView?.removeFromSuperview()
        }
    }
    
    func addDestinationRepresentationView() {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "y/MMMM/d"
        
        if destinationDate.1 == nil {
            destinationDate.1 = destinationDate.0
        }
        
        guard let city = selectedCity, let startDate = destinationDate.0, let endDate = destinationDate.1 else {return}
        let destination = Destination(city: city, startDate: formatter.string(from: startDate), endDate: formatter.string(from: endDate))
        
        trip.destinations.append(destination)
        let mapDict = Helper.createDestinationDicionary(destination: destination)
        destinationsArray.append(mapDict)
        destinationsCollectionView.isHidden = false
        destinationsCollectionView.reloadData()
    }
    
    func createTrip() {
        guard let description = descriptionTextView.text, let name = tripNameTextField.text else {return}
        
        trip.name = name
        trip.description = description
        trip.trip_start_date = trip.destinations.first?.startDate
        trip.trip_end_date = trip.destinations.last?.endDate
        
        tripService.createTrip(trip: trip, destinationsArray: destinationsArray) { (error) in
            if error == nil {
                print(error?.localizedDescription)
            }
        }
    }
    
    // text field is empty - show red border
    func errorHighlightTextField() {
        let color = UIColor.red.cgColor
        descriptionTextView.layer.borderColor = color
        descriptionTextView.layer.borderWidth = 1.0
        tripNameTextField.layer.borderColor = color
        tripNameTextField.layer.borderWidth = 1.0
    }
    
    func removeErrorHighlight() {
        let color = UIColor.lightGray.cgColor
        descriptionTextView.layer.borderColor = color
        descriptionTextView.layer.borderWidth = 1.0
        tripNameTextField.layer.borderColor = color
        tripNameTextField.layer.borderWidth = 1.0
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let description = descriptionTextView.text, description != "" else {
            errorHighlightTextField()
            createTripButton.isEnabled = false
            return
        }
        if doesTextFieldHaveValue {
            removeErrorHighlight()
            createTripButton.isEnabled = true
        } else {
            errorHighlightTextField()
            createTripButton.isEnabled = false
        }
        
    }
}
