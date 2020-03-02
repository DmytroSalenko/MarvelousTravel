//
//  SignUpViewModel.swift
//  SignInScreen
//
//  Created by Dmytro Salenko on 2/20/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation

class UserRegisterViewModel {
    // fields
    var model : SignUpData
    let emailViewModel: Observable<String>
    let passwordViewModel: Observable<String>
    let confirmPasswordViewModel: Observable<String>
    let firstNameViewModel: Observable<String>
    let lastNameViewModel: Observable<String>
    let placeOfLivingViewModel: Observable<String>
    let avatarPathViewModel: Observable<String>
    
    // completion flags
    let isEmailValid: Observable<Bool>
    let isPasswordValid: Observable<Bool>
    let isPasswordConfirmed: Observable<Bool>
    let isLastNameValid: Observable<Bool>
    let isFirstNameValid: Observable<Bool>
    let isInputValid: Observable<Bool>
    let isLoading: Observable<Bool>
    let isRegistered: Observable<Bool>
    
    let client = UserService(config: URLSessionConfiguration.default)
    
    init() {
        model = SignUpData()
        emailViewModel = Observable("")
        isEmailValid = Observable(false)
        passwordViewModel = Observable("")
        confirmPasswordViewModel = Observable("")
        isPasswordValid = Observable(false)
        isPasswordConfirmed = Observable(false)
        firstNameViewModel = Observable("")
        lastNameViewModel = Observable("")
        isFirstNameValid = Observable(false)
        isLastNameValid = Observable(false)
        placeOfLivingViewModel = Observable("")
        avatarPathViewModel = Observable("")
        isInputValid = Observable(false)
        isLoading = Observable(false)
        isRegistered = Observable(false)
    }
    
    func validateEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        isEmailValid.value = emailTest.evaluate(with: self.emailViewModel.value)
        return isEmailValid.value!
    }
        
    func validatePassword() -> Bool {
        let passwordRegEx = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        isPasswordValid.value = passwordTest.evaluate(with: self.passwordViewModel.value)
        return isPasswordValid.value!
    }
    
    func validateConfirmation() -> Bool {
        isPasswordConfirmed.value = (passwordViewModel.value == confirmPasswordViewModel.value) && (confirmPasswordViewModel.value != "")
        return isPasswordConfirmed.value!
    }
    
    func validateFirstName() -> Bool{
        let nameRegEx = "^[a-zA-Z]{2,18}$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        isFirstNameValid.value = nameTest.evaluate(with: firstNameViewModel.value)
        return isFirstNameValid.value!
    }
    
    func validateLastName() -> Bool {
        let nameRegEx = "^[a-zA-Z]{2,18}$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        isLastNameValid.value = nameTest.evaluate(with: lastNameViewModel.value)
        return isLastNameValid.value!
    }
    
    func validateUserInput() {
//        self.isRegistered.value = true
        let result = [validateEmail(), validatePassword(), validateConfirmation(), validateFirstName(), validateLastName()].allSatisfy({$0 == true})
        if result {
            isLoading.value = true
            client.checkEmailAvailability(email: emailViewModel.value!,
            onCompletion: {
              isAvailable in
                if isAvailable {
                    self.isInputValid.value = true
                    self.registerUser()
                } else {
                    self.isInputValid.value = false
                }
                self.isLoading.value = false
            })
        }
    }
    
    func registerUser() {
        model.email = emailViewModel.value!
        model.password = passwordViewModel.value!
        model.first_name = firstNameViewModel.value!
        model.last_name = lastNameViewModel.value!
        
        isLoading.value = true
        do {
            try client.registerUser(model,
            onSuccess:  {
                userData in
                self.isLoading.value = false
                self.isRegistered.value = true
//                let defaults = UserDefaults.standard
//                defaults.set(userData._id, forKey: "user_id")
            }, onError: {
                error in
                self.isLoading.value = false
                self.isRegistered.value = false
            })
        } catch {
            self.isLoading.value = false
            self.isRegistered.value = false
        }
    }
}
