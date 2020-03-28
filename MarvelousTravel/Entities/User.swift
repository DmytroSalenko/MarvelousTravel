//
//  User.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/2/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation

class User: Codable {
    var _id: String?
    var email: String?
    var password_hash: String?
    var create_at : Date?
    var first_name: String?
    var last_name: String?
    var icon_path: String?
    var mini_icon_path: String?
    var place_of_living: City?
    var date_of_birth : Date?
    var images_path = [String]()
    var trips = [String]()
    var chats = [String]()
    var interests : String?
    var about : String?
    
    var dictionary: [String: Any?] {
        return ["_id": _id,
                "email": email,
                "password_hash": password_hash,
                "create_at": create_at,
                "first_name": first_name,
                "last_name": last_name,
                "icon_path": icon_path,
                "mini_icon_path": mini_icon_path,
                "place_of_living": place_of_living,
                "interests": interests,
                "date_of_birth": date_of_birth,
                "images_path": images_path,
                "trips": trips,
                "chats": chats]
    }
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}


class AuthenticationResponse: Codable {
    var user: User?
    var token_data: AuthToken?
}
