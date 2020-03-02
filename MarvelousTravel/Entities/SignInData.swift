//
//  SignInData.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/2/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation

class SignInData: Codable {
    var email: String = ""
    var password: String = ""
    
    
    convenience init(email: String, password: String) {
        self.init()
        self.email = email
        self.password = password
    }
}

class AuthToken: Codable {
    var access_token: String = ""
    var token_type: String = ""
    
    convenience init(access_token: String, token_type: String) {
        self.init()
        self.access_token = access_token
    }
}

