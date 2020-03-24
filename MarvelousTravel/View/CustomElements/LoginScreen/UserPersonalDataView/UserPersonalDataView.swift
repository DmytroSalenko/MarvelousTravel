//
//  UserProfileDataView.swift
//  SignInScreen
//
//  Created by Dmytro Salenko on 2/26/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit
import BFWControls
import SkyFloatingLabelTextField

class UserPersonalDataView: NibView {
    @IBOutlet weak var firstNameContainer: UIView!
    @IBOutlet weak var lastNameContainer: UIView!
    @IBOutlet weak var firstNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var lastNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var finishButton: UIButton!
    
    let viewModel = UserPersonalDataViewModel()
    
    let isImagePickRequested: Observable<Bool> = Observable(false)
    
    // flags
    var isResetRequested: Observable<Bool> = Observable(false)
    var isTransitionRequested: Observable<Bool> = Observable(false)
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        iconImageView.isUserInteractionEnabled = true
        iconImageView.addGestureRecognizer(tapGestureRecognizer)
        
        configureFirstNameField()
        configureLastNameField()
        
        finishButton.addTarget(self, action: #selector(finishRegistration), for: .touchUpInside)
        
        self.observe(for: viewModel.image) {
            value in
            self.iconImageView.image = value
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        isImagePickRequested.value = true
    }
    
    @objc func finishRegistration(sender: UIButton) {
        viewModel.validateUserInputAndUpdate()
    }
    
    func configureFirstNameField() {
        firstNameTextField.delegate = self
        firstNameTextField.bind(with: viewModel.firstNameViewModel)
        firstNameTextField.addTarget(self, action: #selector(validateFirstName), for: .editingDidEnd)
        firstNameTextField.setValidator(validator: viewModel.firstNameErrorMessage)

        firstNameContainer.layer.masksToBounds = true
        firstNameContainer.layer.cornerRadius = firstNameContainer.frame.height / 4
    }
    
    func configureLastNameField() {
        lastNameTextField.delegate = self
        lastNameTextField.bind(with: viewModel.lastNameViewModel)
        lastNameTextField.addTarget(self, action: #selector(validateLastName), for: .editingDidEnd)
        lastNameTextField.setValidator(validator: viewModel.lastNameErrorMessage)
        
        lastNameContainer.layer.masksToBounds = true
        lastNameContainer.layer.cornerRadius = lastNameContainer.frame.height / 4
    }
    
    @objc func validateFirstName(sender: UITextField) {
        let _ = viewModel.validateFirstName()
    }
    
    @objc func validateLastName(sender: UITextField) {
        let _ = viewModel.validateLastName()
    }
}

extension UserPersonalDataView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}


