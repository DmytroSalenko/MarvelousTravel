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
//    let firstNameViewModel: Observable<String>
//    let lastNameViewModel: Observable<String>
    let placeOfLivingViewModel: Observable<String>
    let avatarPathViewModel: Observable<String>
    // validation error messages
    let emailErrorMessage: Observable<String>
    let passwordErrorMessage: Observable<String>
    let confirmPasswordErrorMessage: Observable<String>
//    let lastNameErrorMessage: Observable<String>
//    let firstNameErrorMessage: Observable<String>
    // completion flags
    let isInputValid: Observable<Bool>
    let isLoading: Observable<Bool>
    let isRegistered: Observable<Bool>
    
    let client = UserService(config: URLSessionConfiguration.default)
    
    init() {
        model = SignUpData()
        emailViewModel = Observable("")
        passwordViewModel = Observable("")
        confirmPasswordViewModel = Observable("")
        
        emailErrorMessage = Observable("")
        passwordErrorMessage = Observable("")
        confirmPasswordErrorMessage = Observable("")
//        firstNameErrorMessage = Observable("")
//        lastNameErrorMessage = Observable("")
//
//        firstNameViewModel = Observable("")
//        lastNameViewModel = Observable("")

        placeOfLivingViewModel = Observable("")
        avatarPathViewModel = Observable("")
        isInputValid = Observable(false)
        isLoading = Observable(false)
        isRegistered = Observable(false)
    }
    
    func validateEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailViewModel.value!.isEmpty {
            emailErrorMessage.value = "Email field is empty"
            return false
        }
        let result = emailTest.evaluate(with: self.emailViewModel.value)
        emailErrorMessage.value = result ? "" : "Incorrect email format"
        return result
    }
        
    func validatePassword() -> Bool {
        let passwordRegEx = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        if passwordViewModel.value!.isEmpty {
            passwordErrorMessage.value = "Password field is empty"
            return false
        }
        let result = passwordTest.evaluate(with: self.passwordViewModel.value)
        passwordErrorMessage.value = result ? "" : "Incorrect password format"
        return result
    }
    
    func validateConfirmation() -> Bool {
        if confirmPasswordViewModel.value!.isEmpty {
            confirmPasswordErrorMessage.value = "Password confirmation field is empty"
            return false
        }
        let result = (passwordViewModel.value == confirmPasswordViewModel.value)
        confirmPasswordErrorMessage.value = result ? "" : "Passwords do not match"
        return result
    }
    
//    func validateFirstName() -> Bool{
//        let nameRegEx = "^[a-zA-Z]{2,18}$"
//        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
//        if firstNameViewModel.value!.isEmpty {
//            firstNameErrorMessage.value = "First name is empty"
//            return false
//        }
//        let result = nameTest.evaluate(with: firstNameViewModel.value)
//        firstNameErrorMessage.value = result ? "" : "Incorrect first name format"
//        return result
//    }
//    
//    func validateLastName() -> Bool {
//        let nameRegEx = "^[a-zA-Z]{2,18}$"
//        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
//        if lastNameViewModel.value!.isEmpty {
//            lastNameErrorMessage.value = "Last name is empty"
//            return false
//        }
//        let result = nameTest.evaluate(with: lastNameViewModel.value)
//        lastNameErrorMessage.value = result ? "" : "Incorrect last name format"
//        return result
//    }
    
    func validateUserInputAndRegister() {
//        self.isRegistered.value = true
        let result = [validateEmail(), validatePassword(), validateConfirmation()].allSatisfy({$0 == true})
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
//        model.first_name = firstNameViewModel.value!
//        model.last_name = lastNameViewModel.value!
        
        isLoading.value = true
        do {
            try client.registerUser(model,
            onSuccess:  {
                registerData in
                self.isLoading.value = false
                self.isRegistered.value = true
                let defaults = UserDefaults.standard
                defaults.set(registerData.token_data?.access_token, forKey: "tokenData")
                defaults.set(registerData.user?._id, forKey: "userId")
                defaults.set(registerData.user?.first_name, forKey: "userFirstName")
                defaults.set(registerData.user?.last_name, forKey: "userLastName")
                defaults.set(registerData.user?.email, forKey: "userEmail")
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
