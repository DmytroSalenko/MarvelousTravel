//
//  SettingsViewModel.swift
//  MarvelousTravel
//
//  Created by  Ilia Goncharenko on 2020-03-26.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation

class SettingsViewModel {
    var firstName : String
    var lastName : String
    var about : String
    var interests : String
    
    init(firstName : String, lastName : String, about : String, interests : String) {
        self.firstName = firstName
        self.lastName = lastName
        self.about = about
        self.interests = interests
    }
    
}
