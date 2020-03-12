//
//  CreateTripExtension.swift
//  MarvelousTravel
//
//  Created by  Ilia Goncharenko on 2020-03-06.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation
import UIKit

extension CreateTripViewController {
    
    func getCities(inputString: String) {
        cityService.citiesAutocompletionQuery(inputString, 10, onSuccess: { (cities) in
            self.autoCompletePossibilities += cities
        }) { (error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // adjust table view height according to mathces
        adjustTableViewHeight(numberOfItems: autoComplete.count) //autoComplete.count
        // if no matches, dont show table view
        if autoComplete.count > 0 {
            self.destinationView?.tableView.isHidden = false
            return autoComplete.count
        } else {
            self.destinationView?.tableView.isHidden = true
            return 0
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = destinationView?.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let index = indexPath.row
        cell?.textLabel?.text = autoComplete[index].getFormattedFullName()
        return cell!
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text!.count > 0{
            getCities(inputString: textField.text!)
        if string.isEmpty {
            if textField.text?.count == 1 {
                destinationView?.tableView.isHidden = true
                return true
            } else {
                createSubstring(text: textField.text, in: range, string: string)
                return true
            }
        } else {
            createSubstring(text: textField.text, in: range, string: string)
            return true
        }
        } else {
            return true
        }
    }

    func createSubstring(text: String?, in range: NSRange, string: String) {
        let substring = (text! as NSString).replacingCharacters(in: range, with: string)
        searchAutoCompleteEntriesWithSubstring(substring)
    }

    func searchAutoCompleteEntriesWithSubstring(_ substring: String) {
        destinationView?.tableView.isHidden = false
        autoComplete.removeAll()
        for key in autoCompletePossibilities {
            let myString : NSString! = key.name as! NSString
            let substringRange : NSRange! = myString.range(of: substring)
            if substringRange.location == 0 {
                if !autoComplete.contains(key){
                autoComplete.append(key)
                }
            }
        }
        destinationView?.tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRow = tableView.cellForRow(at: indexPath)
        destinationView?.cityTextField.text = selectedRow?.textLabel?.text!
        destinationView?.tableView.isHidden = true
        selectedCity = autoComplete[indexPath.row]
        print(selectedCity)
        destinationView?.selectDateButton.isEnabled = true
    }

    func adjustTableViewHeight(numberOfItems : Int) {
        var height = destinationView?.tableView.contentSize.height
        // only one match in table view
        if numberOfItems == 1{
            height = 43.3
        // two matches in table view
        }else if numberOfItems == 2{
            height = 87.0
        }else {
            // default height of table view
            height = 130.0
        }

        var frame = self.destinationView?.tableView.frame
        frame?.size.height = height!
        self.destinationView?.tableView.frame = frame!
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
}
