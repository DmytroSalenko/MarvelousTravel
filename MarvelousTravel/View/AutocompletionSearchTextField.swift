//
//  AutocompletionSearchTextField.swift
//  SignInScreen
//
//  Created by Dmytro Salenko on 2/27/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit
import CoreData

class AutocompletionSearchTextField: UITextField {
//    var dataList: [String] = [String]()
    var tableView: UITableView?
    var citySelected: City?
    let viewModel =  AutocompleteSearchTextFieldViewModel()
    
    // Connecting the new element to the parent view
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        tableView?.removeFromSuperview()
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        self.addTarget(self, action: #selector(AutocompletionSearchTextField.textFieldDidChange), for: .editingChanged)
        self.addTarget(self, action: #selector(AutocompletionSearchTextField.textFieldDidBeginEditing), for: .editingDidBegin)
        self.addTarget(self, action: #selector(AutocompletionSearchTextField.textFieldDidEndEditing), for: .editingDidEnd)
        self.addTarget(self, action: #selector(AutocompletionSearchTextField.textFieldDidEndEditingOnExit), for: .editingDidEndOnExit)
        
        self.observe(for: viewModel.resultsList) {
            value in
            if self.isEditing {
                self.filter()
            }
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        buildSearchTableView()
    }
    
    @objc open func textFieldDidChange() {
        let searchText = self.text!
         if searchText.count >= 3 {
             viewModel.getSuggestedCitiesList(searchText)
         } else {
             self.tableView?.isHidden = true
         }
    }
    
    @objc open func textFieldDidBeginEditing() {
    }
    
    @objc open func textFieldDidEndEditing() {
        tableView?.isHidden = true
    }
    
    @objc open func textFieldDidEndEditingOnExit() {
        tableView?.isHidden = true
    }
    
    func filter() {
        self.tableView?.reloadData()
        self.updateSearchTableView()
        self.tableView?.isHidden = false
    }
}

extension AutocompletionSearchTextField: UITableViewDelegate, UITableViewDataSource {
    func buildSearchTableView() {

        if let tableView = tableView {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CustomSearchTextFieldCell")
            tableView.delegate = self
            tableView.dataSource = self
            self.window?.addSubview(tableView)

        } else {
//            addData()
            tableView = UITableView(frame: CGRect.zero)
        }
        
        updateSearchTableView()
    }
    
    func updateSearchTableView() {
        
        if let tableView = tableView {
            superview?.bringSubviewToFront(tableView)
            var tableHeight: CGFloat = 0
            tableHeight = tableView.contentSize.height
            
            // Set a bottom margin of 10p
            if tableHeight < tableView.contentSize.height {
                tableHeight -= 10
            }
            
            // Set tableView frame
            var tableViewFrame = CGRect(x: 0, y: 0, width: frame.size.width - 4, height: tableHeight)
            tableViewFrame.origin = self.convert(tableViewFrame.origin, to: nil)
            tableViewFrame.origin.x += 2
            tableViewFrame.origin.y += frame.size.height + 2
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.tableView?.frame = tableViewFrame
            })
            
            //Setting tableView style
            tableView.layer.masksToBounds = true
            tableView.separatorInset = UIEdgeInsets.zero
            tableView.layer.cornerRadius = 5.0
            tableView.separatorColor = UIColor.lightGray
            tableView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            
            if self.isFirstResponder {
                superview?.bringSubviewToFront(self)
            }
            
            tableView.reloadData()
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.resultsList.value!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomSearchTextFieldCell", for: indexPath) as UITableViewCell
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = viewModel.resultsList.value![indexPath.row].getFormattedFullName()
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.text = viewModel.resultsList.value![indexPath.row].getFormattedFullName()
        self.viewModel.selectedCity.value = viewModel.resultsList.value![indexPath.row]
        self.viewModel.isSelected.value = true
        tableView.isHidden = true
        self.endEditing(true)
    }
    
//    func addData(){
//        let a = "Paris"
//        let b = "Porto"
//        let c = "Pavard"
//
//        dataList.append(a)
//        dataList.append(b)
//        dataList.append(c)
//    }
}
