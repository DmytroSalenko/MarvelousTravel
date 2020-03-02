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
    var interests : String?
    var date_of_birth : Date?
    var images_path = [String]()
    var trips = [String]()
    var chats = [String]()
}
