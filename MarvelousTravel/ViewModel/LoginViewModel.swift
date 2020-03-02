//
//  LoginViewModel.swift
//  SignInScreen
//
//  Created by Dmytro Salenko on 2/9/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation

class LoginViewModel {
    let email: Observable<String>
    let password: Observable<String>
    let isLoading: Observable<Bool>
    let isLoggedIn : Observable<Bool>
    let loginModel: SignInData
    
    let client = UserService(config: URLSessionConfiguration.default)

    init() {
        email = Observable("")
        password = Observable("")
        isLoggedIn = Observable(false)
        isLoading = Observable(false)
        loginModel = SignInData()
    }
    
    func loginUser() {
        // Initialise model with filed values
        loginModel.email = email.value!
        loginModel.password = password.value!

        self.isLoading.value = true
        do {
            try client.logIn(loginModel,
            onSuccess: { tokenData in
                self.isLoading.value = false
                self.isLoggedIn.value = true
                let defaults = UserDefaults.standard
                defaults.set(tokenData.access_token, forKey: "accessToken")
            },
            onError: { error in
                self.isLoading.value = false
                self.isLoggedIn.value = false
            })
        } catch {
            self.isLoggedIn.value = false
        }
    }
}


