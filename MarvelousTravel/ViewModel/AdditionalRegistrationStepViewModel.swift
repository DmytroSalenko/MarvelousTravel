//
//  AdditionalRegistrationStepViewModel.swift
//  SignInScreen
//
//  Created by Dmytro Salenko on 2/28/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation
import UIKit


class AdditionalRegistrationStepViewModel {
    var image: Observable<UIImage?>
    var selectedCity: Observable<City?>
    var searchListViewModel: AutocompleteSearchTextFieldViewModel?
    
    // flags
    let isLoading: Observable<Bool>
    let isRegistrationFinished: Observable<Bool>
    let isIconSent: Observable<Bool>
    let isCityUpdated: Observable<Bool>
    
    var client = UserService(config: URLSessionConfiguration.default)
    
    init() {
        image = Observable(nil)
        selectedCity = Observable(nil)
        isRegistrationFinished = Observable(false)
        isIconSent = Observable(false)
        isLoading = Observable(false)
        isCityUpdated = Observable(false)
    }
    
    func finishRegistration() {
        isLoading.value = true
        if image.value != nil {
            do {
                try client.sendUserIcon(image.value!!, onSuccess: {
                    value in
//                    self.client.user_model = value
                    self.isIconSent.value = true
                }, onError: {
                    error in
                    self.isIconSent.value = false
                })
            } catch {
                self.isIconSent.value = false
            }
        } else {
            self.isIconSent.value = true
        }
        
        if selectedCity.value != nil {
            
        } else {
            self.isCityUpdated.value = true
        }
    }
}
