//
//  TimePickerViewController.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/16/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit
import HGCircularSlider

class TimePickerViewController: UIViewController {
    
    var viewModel: CityWalkViewModel?
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var showCityWalkButton: UIButton!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var hoursCircularSlider: CircularSlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        hoursCircularSlider.minimumValue = 3
        hoursCircularSlider.maximumValue = 360
        hoursCircularSlider.endPointValue = 180
        hoursCircularSlider.addTarget(self, action: #selector(updateLabels), for: .valueChanged)
        showCityWalkButton.addTarget(self, action: #selector(goToCityWalkScreen), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(goToRootViewController), for: .touchUpInside)
        updateLabels()
    }
    
    @objc func updateLabels() {
        viewModel!.walkDuration = Int(hoursCircularSlider.endPointValue)
        
        let hours = Int(hoursCircularSlider.endPointValue / 60)
        let minutes = Int(hoursCircularSlider.endPointValue.truncatingRemainder(dividingBy: 60))
        minutesLabel.text = "\(minutes)"
        hoursLabel.text = "\(hours)"
    }
    
    @objc func goToCityWalkScreen() {
        performSegue(withIdentifier: "showCityWalk", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCityWalk" {
            if let cityWalkViewController = segue.destination as? CityWalkViewController {
                cityWalkViewController.viewModel = viewModel
            }
        }
    }
    
    @objc func goToRootViewController() {
        navigationController?.popToRootViewController(animated: true)
    }

}
