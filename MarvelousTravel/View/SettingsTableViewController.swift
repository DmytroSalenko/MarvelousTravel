//
//  SettingsTableViewController.swift
//  MarvelousTravel
//
//  Created by  Ilia Goncharenko on 2020-03-26.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UITextViewDelegate {
    
    var settingsViewModel : SettingsViewModel?
    var currentUser : User?
    let userService = UserService(config: URLSessionConfiguration.default)
    
    let sections : [String] = ["First Name", "Last Name", "About", "Interests", "Confirm Changes:"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 500
        self.tableView.separatorStyle = .none
        
        guard let user = currentUser else {return}
        settingsViewModel = SettingsViewModel(firstName: user.first_name!, lastName: user.last_name!, about: user.about!, interests: user.interests!)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            let title = sections[section]
            return title
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PersonalInitialsTableViewCell
            cell.infoTextField.text = settingsViewModel?.firstName
            cell.infoTextField.tag = 0
            cell.infoTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            return cell
        } else if indexPath.section == 1 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PersonalInitialsTableViewCell
            cell.infoTextField.text = settingsViewModel?.lastName
            cell.infoTextField.tag = 1
            cell.infoTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            return cell
        } else if indexPath.section == 2 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "aboutCell", for: indexPath) as! AboutAndInteresetsTableViewCell
            cell.textView.text = settingsViewModel?.about
            cell.textView.tag = 0
            cell.textView.delegate = self
            return cell
        } else if indexPath.section == 3 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "aboutCell", for: indexPath) as! AboutAndInteresetsTableViewCell
            cell.textView.text = settingsViewModel?.interests
            cell.textView.tag = 1
            cell.textView.delegate = self
            return cell
        } else if indexPath.section == 4 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "submitCell", for: indexPath) as! SubmitButtonTableViewCell
            cell.submitButton.setTitle("Submit", for: .normal)
            cell.submitButton.addTarget(self, action: #selector(submitButtonOnTouch), for: .touchDown)
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func textFieldDidChange(sender : UITextField) {
        // name
        if sender.tag == 0 {
            settingsViewModel?.firstName = sender.text!
        } else if sender.tag == 1 {
            settingsViewModel?.lastName = sender.text!
        }
    }
    
    @objc func submitButtonOnTouch(sender : UIButton) {
        let updatedUser = currentUser
        updatedUser?.first_name = settingsViewModel?.firstName
        updatedUser?.last_name = settingsViewModel?.lastName
        updatedUser?.about = settingsViewModel?.about
        updatedUser?.interests = settingsViewModel?.interests
        
        do {
            try userService.updateUserData(updatedUser!, userId: "5e7d6092f3e1b2843f7b702d", onSuccess: { (user) in
                if user != nil {
                    print(user)
                }
            }) { (error) in
                print(error)
            }
        } catch {
            // TODO add something here
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView.tag == 0 {
            settingsViewModel?.about = textView.text
            self.tableView.reloadData()
        } else if textView.tag == 1 {
            settingsViewModel?.interests = textView.text
            self.tableView.reloadData()
        }
    }

}
