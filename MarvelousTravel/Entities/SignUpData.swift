//
//  SignUpData.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/2/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation


class SignUpData: Codable {
    var email: String
    var password: String
    
    init() {
        self.email = ""
        self.password = ""
    }
    
    convenience init(email: String, password_hash: String) {
        self.init()
        self.email = email
        self.password = password_hash
    }
}
