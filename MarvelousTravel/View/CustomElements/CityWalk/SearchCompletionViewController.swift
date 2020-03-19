//
//  SearchCompletionViewController.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/9/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit
import SHSearchBar
import MapKit

class SearchCompletionViewController: UIViewController, SHSearchBarDelegate {
    var viewModel: CityWalkViewModel?
    var searchBar: SHSearchBar!
    var rasterSize: CGFloat = 11.0

    let searchbarHeight: CGFloat = 44.0

    @IBOutlet weak var searchResultsTableView: UITableView!
    @IBOutlet weak var searchBarBackgroundImage: UIImageView!
    @IBOutlet weak var searchBarStackVIew: UIStackView!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        searchBar = defaultSearchBar(withRasterSize: rasterSize,
                                      leftView: nil,
                                      rightView: nil,
                                      delegate: self)
        
        searchBarStackVIew.addArrangedSubview(searchBar)
        searchBar.textField.becomeFirstResponder()
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    func defaultSearchBar(withRasterSize rasterSize: CGFloat,
                          leftView: UIView?,
                          rightView: UIView?,
                          delegate: SHSearchBarDelegate,
                          useCancelButton: Bool = true) -> SHSearchBar {

        var config = defaultSearchBarConfig(rasterSize)
        config.leftView = leftView
        config.rightView = rightView
        config.useCancelButton = useCancelButton

        if leftView != nil {
            config.leftViewMode = .always
        }

        if rightView != nil {
            config.rightViewMode = .unlessEditing
        }

        let bar = SHSearchBar(config: config)
        bar.delegate = delegate
        bar.placeholder = "Find location"
        bar.updateBackgroundImage(withRadius: 6, corners: [.allCorners], color: UIColor.white)
        bar.layer.shadowColor = UIColor.black.cgColor
        bar.layer.shadowOffset = CGSize(width: 0, height: 3)
        bar.layer.shadowRadius = 5
        bar.layer.shadowOpacity = 0.25
        
        return bar
    }
    
    @objc func backButtonPressed() {
        navigateToMapPicker()
    }

    func defaultSearchBarConfig(_ rasterSize: CGFloat) -> SHSearchBarConfig {
        var config: SHSearchBarConfig = SHSearchBarConfig()
        config.rasterSize = rasterSize
    //    config.cancelButtonTitle = NSLocalizedString("sbe.general.cancel", comment: "")
        config.cancelButtonTextAttributes = [.foregroundColor: UIColor.white]
        config.textContentType = UITextContentType.fullStreetAddress.rawValue
        config.textAttributes = [.foregroundColor: UIColor.gray]
        return config
    }
    
    func searchBar(_ searchBar: SHSearchBar, textDidChange text: String) {
        if text.count >= 2 {
            viewModel!.updateSearchResultsForSearchController(searchBarText: text) {
                result in
                if result {
                    DispatchQueue.main.async {
                        self.searchResultsTableView.reloadData()
                    }
                }
            }
        } else {
            viewModel!.matchingItems = []
            DispatchQueue.main.async {
                self.searchResultsTableView.reloadData()
            }
        }
    }
    
    func navigateToMapPicker() {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension SearchCompletionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel!.matchingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "searchResultsCell")
        let item = viewModel!.matchingItems[indexPath.row].placemark
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = parseAddress(selectedItem: item)
        return cell
    }
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
}

extension SearchCompletionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel!.selectedItem.value = viewModel!.matchingItems[indexPath.row]
        navigateToMapPicker()
    }
}
