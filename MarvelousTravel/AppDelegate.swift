//
//  AppDelegate.swift
//  SignInScreen
//
//  Created by Dmytro Salenko on 2/9/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    static var visibleViewController: UIViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GIDSignIn.sharedInstance()?.clientID = "594467304444-i56gdff7v61kje4v756n2t3j0n9gfj98.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        // Override point for customization after application launch.
        return true
    }
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        return GIDSignIn.sharedInstance().handle(url)
//    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        var currentVC : LoginScreenViewController!
        
//        let userId = user.userID
        let idToken = user.authentication.idToken
//        let fullName = user.profile.name
//        let givenName = user.profile.givenName
//        let familyName = user.profile.familyName
//        let email = user.profile.email
//        let image = user.profile.imageURL(withDimension: 1)
        
        guard let token = idToken else {return}
        currentVC = AppDelegate.visibleViewController as? LoginScreenViewController
        if let currentVC = currentVC {
            currentVC.loginView!.viewModel.googleButtonOnTouch(token: token)
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            let str_URL = url.absoluteString as NSString
            if str_URL.contains("fb880651202407103"){
                return ApplicationDelegate.shared.application(
                        app,
                        open: (url as URL?)!,
                        sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String,
                        annotation: options[UIApplication.OpenURLOptionsKey.annotation])
              }


        return ApplicationDelegate.shared.application(
                    app,
                    open: (url as URL?)!,
                    sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String,
                    annotation: options[UIApplication.OpenURLOptionsKey.annotation])

            }

}

