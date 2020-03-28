//
//  LoginViewModel.swift
//  SignInScreen
//
//  Created by Dmytro Salenko on 2/9/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation
import FBSDKShareKit
import FBSDKLoginKit
import FBSDKCoreKit

enum loginStatus {
    case idle
    case inProgress
    case fail
    case success
}

class LoginViewModel {
    let email: Observable<String>
    let password: Observable<String>
    let loginStatus: Observable<loginStatus>
    let isLoggedIn : Observable<Bool>
    let loginModel: SignInData
    
    let client = UserService(config: URLSessionConfiguration.default)

    init() {
        email = Observable("")
        password = Observable("")
        isLoggedIn = Observable(false)
        loginStatus = Observable(.idle)
        loginModel = SignInData()
    }
    
    func loginUser() {
        // Initialise model with filed values
        loginModel.email = email.value!
        loginModel.password = password.value!

        self.loginStatus.value = .inProgress
        do {
            try client.logIn(loginModel,
            onSuccess: { authData in
                self.loginStatus.value = .success
                self.isLoggedIn.value = true
                let defaults = UserDefaults.standard
                defaults.set(authData.token_data?.access_token, forKey: "accessToken")
                defaults.set(authData.user, forKey: "userData")
            },
            onError: { error in
                self.loginStatus.value = .fail
                self.isLoggedIn.value = false
            })
        } catch {
            self.isLoggedIn.value = false
            self.loginStatus.value = .fail
        }
    }
    
    func facebookLogin() {
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: nil, handler: {
            (result, error) -> Void in
            if (error == nil) {
                let fbloginresult : LoginManagerLoginResult = result!
                if(fbloginresult.isCancelled) {
                     //Show Cancel alert
                } else if(fbloginresult.grantedPermissions.contains("email")) {
                    self.sendFacebookAuthData()
                      //fbLoginManager.logOut()
                }
            }
        })
    }
    
    func sendFacebookAuthData() {
        let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields":"id,email,first_name,last_name,picture.type(small).as(picture_small),picture.type(normal).as(picture_normal)"])
       graphRequest.start(completionHandler: { (connection, result, error) -> Void in
       if ((error) != nil) {
           // Process error
           print("\n Error: \(error)")
       } else {
        let resultDic = result as! NSDictionary
        do  {
            try self.client.fbAuthenticate(data: resultDic, accessToken: AccessToken.current!.tokenString,
                onSuccess: {
                    authData in
                    self.isLoggedIn.value = true
                    let defaults = UserDefaults.standard
                    defaults.set(authData.token_data?.access_token, forKey: "tokenData")
                    defaults.set(authData.user?._id, forKey: "userId")
                    defaults.set(authData.user?.first_name, forKey: "userFirstName")
                    defaults.set(authData.user?.last_name, forKey: "userLastName")
                    defaults.set(authData.user?.email, forKey: "userEmail")
                }, onError: {
                    error in
                    self.isLoggedIn.value = false
                })
            } catch {
                self.isLoggedIn.value = false
            }
        }
       })
    }
    
    func googleButtonOnTouch(token : String) {
        client.googleSignIn(token: token) { (token, error) in
            if let token = token {
                // put token in user defaults here
                print("successful google authentication")
            }
        }
    }
}
