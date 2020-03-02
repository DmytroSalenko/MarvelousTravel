//
//  LoginView.swift
//  SignInScreen
//
//  Created by Dmytro Salenko on 2/19/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit
import BFWControls

class LoginView: NibView {
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var newHereTextLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    
    // flags
    let isTransitionRequested: Observable<Bool> = Observable(false)
    let isLogInSuccessful: Observable<Bool> = Observable(false)
    
    let viewModel = LoginViewModel()
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        emailTextField.bind(with: viewModel.email)
        passwordTextField.bind(with: viewModel.password)
        
        // set actions
        loginButton.addTarget(self, action: #selector(sendLogInRequest), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(requestTransition), for: .touchUpInside)
        
        self.observe(for: viewModel.isLoggedIn) {
            value in
            self.isLogInSuccessful.value = value
        }
    }
    
    @objc func sendLogInRequest(sender: UIButton) {
        viewModel.loginUser()
    }
    
    @objc func requestTransition(sender: UIButton) {
        // send signal to switch to another window
        isTransitionRequested.value = true
    }
    
    
    func clearInput() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
}
