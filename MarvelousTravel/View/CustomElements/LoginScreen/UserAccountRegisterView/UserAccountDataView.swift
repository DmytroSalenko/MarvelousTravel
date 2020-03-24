//
//  UserAccountDataView.swift
//  SignInScreen
//
//  Created by Dmytro Salenko on 2/20/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit
import BFWControls
import SkyFloatingLabelTextField


class UserAccountDataView: NibView {

//    @IBOutlet weak var firstNameTextField: SkyFloatingLabelTextField!
//    @IBOutlet weak var lastNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPasswordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    // containers
    @IBOutlet weak var firstNameContainer: UIView!
    @IBOutlet weak var lastNameContainer: UIView!
    @IBOutlet weak var emailContainer: UIView!
    @IBOutlet weak var passwordContainer: UIView!
    @IBOutlet weak var confirmPasswordContainer: UIView!
    
    // flags
    var isResetRequested: Observable<Bool> = Observable(false)
    var isTransitionRequested: Observable<Bool> = Observable(false)
    
    let viewModel = UserRegisterViewModel()
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        cancelButton.addTarget(self, action: #selector(resetState), for: .touchUpInside)
        
        configureNextButton()
        configureEmailField()
//        configureFirstNameField()
//        configureLastNameField()
        configurePasswordField()
        configureConfirmPasswordField()
        
        // set observers
        self.observe(for: viewModel.isRegistered) {
            value in
            if value {
                self.isTransitionRequested.value = true
            }
        }
    }
    
    func configureNextButton() {
        nextButton.layer.masksToBounds = true
        nextButton.layer.cornerRadius = nextButton.frame.height / 2
        nextButton.addTarget(self, action: #selector(validateAllInputs), for: .touchUpInside)
    }
    
    func configureEmailField() {
        emailTextField.delegate = self
        emailTextField.bind(with: viewModel.emailViewModel)
        emailTextField.addTarget(self, action: #selector(validateEmail), for: .editingDidEnd)
        emailTextField.setValidator(validator: viewModel.emailErrorMessage)

        emailContainer.layer.masksToBounds = true
        emailContainer.layer.cornerRadius = emailContainer.frame.height / 4
    }
    
//    func configureFirstNameField() {
//        firstNameTextField.delegate = self
//        firstNameTextField.bind(with: viewModel.firstNameViewModel)
//        firstNameTextField.addTarget(self, action: #selector(validateFirstName), for: .editingDidEnd)
//        firstNameTextField.setValidator(validator: viewModel.firstNameErrorMessage)
//
//        firstNameContainer.layer.masksToBounds = true
//        firstNameContainer.layer.cornerRadius = firstNameContainer.frame.height / 4
//    }
//
//    func configureLastNameField() {
//        lastNameTextField.delegate = self
//        lastNameTextField.bind(with: viewModel.lastNameViewModel)
//        lastNameTextField.addTarget(self, action: #selector(validateLastName), for: .editingDidEnd)
//        lastNameTextField.setValidator(validator: viewModel.lastNameErrorMessage)
//
//        lastNameContainer.layer.masksToBounds = true
//        lastNameContainer.layer.cornerRadius = lastNameContainer.frame.height / 4
//    }
    
    func configurePasswordField() {
        passwordTextField.delegate = self
        passwordTextField.bind(with: viewModel.passwordViewModel)
        passwordTextField.addTarget(self, action: #selector(validatePassword), for: .editingDidEnd)
        passwordTextField.setValidator(validator: viewModel.passwordErrorMessage)
        
        passwordContainer.layer.masksToBounds = true
        passwordContainer.layer.cornerRadius = passwordContainer.frame.height / 4
    }
    
    func configureConfirmPasswordField() {
        confirmPasswordTextField.delegate = self
        confirmPasswordTextField.bind(with: viewModel.confirmPasswordViewModel)
        confirmPasswordTextField.addTarget(self, action: #selector(confirmPassword), for: .editingDidEnd)
        confirmPasswordTextField.setValidator(validator: viewModel.confirmPasswordErrorMessage)

        confirmPasswordContainer.layer.masksToBounds = true
        confirmPasswordContainer.layer.cornerRadius = confirmPasswordContainer.frame.height / 4
    }
    
    @objc func resetState(sender: UIButton) {
//        clearInput()
//        clearValidation()
        isResetRequested.value = true
        clearInput()
        clearValidation()
    }
    
    @objc func validateEmail(sender: UITextField) {
       let _ = viewModel.validateEmail()
    }
    
    @objc func validatePassword(sender: UITextField) {
        let _ = viewModel.validatePassword()
    }
    
    @objc func confirmPassword(sender: UITextField) {
        let _ = viewModel.validateConfirmation()
    }
    
//    @objc func validateFirstName(sender: UITextField) {
//        let _ = viewModel.validateFirstName()
//    }
//    
//    @objc func validateLastName(sender: UITextField) {
//        let _ = viewModel.validateLastName()
//    }
    
    @objc func validateAllInputs(sender: UIButton) {
        let _ = viewModel.validateUserInputAndRegister()
    }
    
    func clearInput() {
        emailTextField.text = ""
//        firstNameTextField.text = ""
//        lastNameTextField.text = ""
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
    }
    
    func clearValidation() {
        emailTextField.markAsValidated(errorMessage: "")
        passwordTextField.markAsValidated(errorMessage: "")
        confirmPasswordTextField.markAsValidated(errorMessage: "")
//        firstNameTextField.markAsValidated(errorMessage: "")
//        lastNameTextField.markAsValidated(errorMessage: "")
    }
}


extension SkyFloatingLabelTextField {
    func markAsValidated(errorMessage: String) {
        self.errorMessage = errorMessage
    }
    
    func setValidator(validator: Observable<String>) {
        self.observe(for: validator) {
            value in
            self.markAsValidated(errorMessage: value)
        }
    }
}

extension UserAccountDataView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

