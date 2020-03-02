//
//  UserAccountDataView.swift
//  SignInScreen
//
//  Created by Dmytro Salenko on 2/20/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit
import BFWControls

class UserAccountDataView: NibView {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    // flags
    var isResetRequested: Observable<Bool> = Observable(false)
    var isTransitionRequested: Observable<Bool> = Observable(false)
    
    let viewModel = UserRegisterViewModel()
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        // bind data
        firstNameTextField.bind(with: viewModel.firstNameViewModel)
        lastNameTextField.bind(with: viewModel.lastNameViewModel)
        emailTextField.bind(with: viewModel.emailViewModel)
        passwordTextField.bind(with: viewModel.passwordViewModel)
        confirmPasswordTextField.bind(with: viewModel.confirmPasswordViewModel)
        // set actions
        cancelButton.addTarget(self, action: #selector(resetState), for: .touchUpInside)
        emailTextField.addTarget(self, action: #selector(validateEmail), for: .editingDidEnd)
        passwordTextField.addTarget(self, action: #selector(validatePassword), for: .editingDidEnd)
        confirmPasswordTextField.addTarget(self, action: #selector(confirmPassword), for: .editingDidEnd)
        firstNameTextField.addTarget(self, action: #selector(validateFirstName), for: .editingDidEnd)
        lastNameTextField.addTarget(self, action: #selector(validateLastName), for: .editingDidEnd)
        nextButton.addTarget(self, action: #selector(validateAllInputs), for: .touchUpInside)
        // set validation
        emailTextField.setValidator(validator: viewModel.isEmailValid)
        passwordTextField.setValidator(validator: viewModel.isPasswordValid)
        confirmPasswordTextField.setValidator(validator: viewModel.isPasswordConfirmed)
        firstNameTextField.setValidator(validator: viewModel.isFirstNameValid)
        lastNameTextField.setValidator(validator: viewModel.isLastNameValid)
        
        // set observers
        self.observe(for: viewModel.isRegistered) {
            value in
            if value {
                self.isTransitionRequested.value = true
            }
        }
    }
    
    @objc func resetState(sender: UIButton) {
        clearInput()
        clearValidation()
        isResetRequested.value = true
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
    
    @objc func validateFirstName(sender: UITextField) {
        let _ = viewModel.validateFirstName()
    }
    
    @objc func validateLastName(sender: UITextField) {
        let _ = viewModel.validateLastName()
    }
    
    @objc func validateAllInputs(sender: UIButton) {
        let _ = viewModel.validateUserInput()
    }
    
    func clearInput() {
        emailTextField.text = ""
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
    }
    
    func clearValidation() {
        emailTextField.markAsValidated(isValid: true)
        passwordTextField.markAsValidated(isValid: true)
        confirmPasswordTextField.markAsValidated(isValid: true)
        firstNameTextField.markAsValidated(isValid: true)
        lastNameTextField.markAsValidated(isValid: true)
    }
}
