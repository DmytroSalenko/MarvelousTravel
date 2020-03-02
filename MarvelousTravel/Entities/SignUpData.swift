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
    var first_name: String
    var last_name: String
    
    init() {
        self.email = ""
        self.password = ""
        self.first_name = ""
        self.last_name = ""
    }
    
    convenience init(email: String, password_hash: String, first_name: String,
                     last_name: String) {
        self.init()
        self.email = email
        self.password = password_hash
        self.first_name = first_name
        self.last_name = last_name
    }
}
