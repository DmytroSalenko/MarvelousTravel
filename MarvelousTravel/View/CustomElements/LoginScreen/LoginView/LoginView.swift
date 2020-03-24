//
//  LoginView.swift
//  SignInScreen
//
//  Created by Dmytro Salenko on 2/19/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit
import BFWControls
import SkyFloatingLabelTextField



class LoginView: NibView {
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var loginButton: AnimatedLoginButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var revealPasswordButton: UIButton!
    @IBOutlet weak var emailContainer: UIView!
    @IBOutlet weak var passwordContainer: UIView!
    @IBOutlet weak var facebookLoginButton: UIButton!
    
    // flags
    let isTransitionRequested: Observable<Bool> = Observable(false)
    let isLogInSuccessful: Observable<Bool> = Observable(false)
    
    let viewModel = LoginViewModel()
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.bind(with: viewModel.email)
        passwordTextField.bind(with: viewModel.password)
        
        // set actions
        loginButton.addTarget(self, action: #selector(sendLogInRequest), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(requestTransition), for: .touchUpInside)
        revealPasswordButton.addTarget(self, action: #selector(revealPassword), for: .touchDown)
        revealPasswordButton.addTarget(self, action: #selector(hidePassword), for: .touchUpInside)
        facebookLoginButton.addTarget(self, action: #selector(loginFb), for: .touchUpInside)
        
        configureTextFieldContainer(container: emailContainer)
        configureTextFieldContainer(container: passwordContainer)
        configureLoginButton()
        configureFacebookLoginButton()

                
        self.observe(for: viewModel.isLoggedIn) {
            value in
            self.isLogInSuccessful.value = value
        }
        
        self.observe(for: viewModel.loginStatus) {
            value in
            switch value {
                case .inProgress:
                    self.loginButton.startAnimation()
                case .fail:
                    self.loginButton.stopAnimation(animationStyle: .shake)
                case .success:
                    self.loginButton.stopAnimation()
                default:
                    self.loginButton.stopAnimation()
            }
        }
    }
    
    func configureFacebookLoginButton() {
        facebookLoginButton.layer.masksToBounds = true
        facebookLoginButton.layer.cornerRadius = facebookLoginButton.frame.width / 2
    }
    
    @objc func sendLogInRequest(sender: UIButton) {
        viewModel.loginUser()
    }
    
    @objc func requestTransition(sender: UIButton) {
        // send signal to switch to another window
        isTransitionRequested.value = true
    }
    
    @objc func revealPassword() {
        passwordTextField.isSecureTextEntry = false
    }
    
    @objc func hidePassword() {
        passwordTextField.isSecureTextEntry = true
    }
    
    @objc func loginFb(_ sender: Any) {
        viewModel.facebookLogin()
    }
    
    func clearInput() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    func configureLoginButton() {
        loginButton.layer.shadowRadius = 10
        loginButton.layer.shadowOpacity = 1
    }
    
    func configureTextFieldContainer(container: UIView, divisor: Int = 4) {
        container.layer.cornerRadius = container.frame.height / 4
        container.layer.masksToBounds = true
    }
}

extension LoginView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
