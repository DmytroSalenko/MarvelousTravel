//
//  AdditionalRegistrationStepViewModel.swift
//  SignInScreen
//
//  Created by Dmytro Salenko on 2/28/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation
import UIKit

enum registrationStatus {
    case idle
    case inProgress
    case fail
    case success
}

class UserPersonalDataViewModel {
    let image: Observable<UIImage?>
    let selectedCity: Observable<City?>
    var searchListViewModel: AutocompleteSearchTextFieldViewModel?
    let firstNameViewModel: Observable<String>
    let lastNameViewModel: Observable<String>
    
    let lastNameErrorMessage: Observable<String>
    let firstNameErrorMessage: Observable<String>
    // flags
    let isLoading: Observable<Bool>
    let registrationStatus: Observable<registrationStatus>
    let isIconSent: Observable<Bool>
    let isCityUpdated: Observable<Bool>
    
    var client = UserService(config: URLSessionConfiguration.default)
    
    init() {
        image = Observable(nil)
        selectedCity = Observable(nil)
        registrationStatus = Observable(.idle)
        isIconSent = Observable(false)
        isLoading = Observable(false)
        isCityUpdated = Observable(false)
        
        firstNameErrorMessage = Observable("")
        lastNameErrorMessage = Observable("")
        firstNameViewModel = Observable("")
        lastNameViewModel = Observable("")
    }
    
//    func finishRegistration() {
//        isLoading.value = true
//        if image.value != nil {
//            do {
//                try client.sendUserIcon(image.value!!, onSuccess: {
//                    value in
////                    self.client.user_model = value
//                    self.isIconSent.value = true
//                }, onError: {
//                    error in
//                    self.isIconSent.value = false
//                })
//            } catch {
//                self.isIconSent.value = false
//            }
//        } else {
//            self.isIconSent.value = true
//        }
//
//        if selectedCity.value != nil {
//
//        } else {
//            self.isCityUpdated.value = true
//        }
//    }
    
    func validateFirstName() -> Bool{
        let nameRegEx = "^[a-zA-Z]{2,18}$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        if firstNameViewModel.value!.isEmpty {
            firstNameErrorMessage.value = "First name is empty"
            return false
        }
        let result = nameTest.evaluate(with: firstNameViewModel.value)
        firstNameErrorMessage.value = result ? "" : "Incorrect first name format"
        return result
    }
    
    func validateLastName() -> Bool {
        let nameRegEx = "^[a-zA-Z]{2,18}$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        if lastNameViewModel.value!.isEmpty {
            lastNameErrorMessage.value = "Last name is empty"
            return false
        }
        let result = nameTest.evaluate(with: lastNameViewModel.value)
        lastNameErrorMessage.value = result ? "" : "Incorrect last name format"
        return result
    }
    
    func validateUserInputAndUpdate() {
        let result = [validateFirstName(), validateLastName()].allSatisfy({$0 == true})
        if result {
            updateUserAccount()
        }
    }
    
    func updateUserAccount() {
        let defaults = UserDefaults.standard
        guard let id = defaults.object(forKey: "userId") as? String else {return}
        registrationStatus.value = .inProgress
        let updatedUserModel = User()
        updatedUserModel.first_name = firstNameViewModel.value
        updatedUserModel.last_name = lastNameViewModel.value
        do {
            try client.updateUserData(updatedUserModel, userId: id, onSuccess: {
                updatedUserData in
                defaults.set(updatedUserData._id, forKey: "userId")
                defaults.set(updatedUserData.first_name, forKey: "userFirstName")
                defaults.set(updatedUserData.last_name, forKey: "userLastName")
                defaults.set(updatedUserData.email, forKey: "userEmail")
                if self.image.value != nil {
                    do {
                        try self.client.sendUserIcon(self.image.value!!, usesrId: id, onSuccess: {
                            value in
        //                    self.client.user_model = value
                            self.registrationStatus.value = .success
                        }, onError: {
                            error in
                            self.isIconSent.value = false
                            self.registrationStatus.value = .fail
                        })
                    } catch {
                        self.isIconSent.value = false
                        self.registrationStatus.value = .fail
                    }
                } else {
                    self.registrationStatus.value = .success
                }
            }, onError: {
                error in
                self.registrationStatus.value = .fail
            })
        } catch {
            self.registrationStatus.value = .fail
        }
    }
}
