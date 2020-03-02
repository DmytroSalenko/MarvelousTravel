//
//  LocationModel.swift
//  SignInScreen
//
//  Created by Dmytro Salenko on 2/27/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation

class City: Codable {
    var id: String
    var parent_id: String
    var country_id: String
    var name: String
    var snippet: String
    
    init() {
        self.id = ""
        self.parent_id = ""
        self.country_id = ""
        self.name = ""
        self.snippet = ""
    }
    
    public func getFormatedName() -> String {
        return name.replacingOccurrences(of: "_", with: " ")
    }
    
    public func getFormattedCountryName() -> String {
        return country_id.replacingOccurrences(of: "_", with: " ")
    }
    
    public func getFormattedFullName() -> String {
        return String(format: "%@, %@", getFormatedName(), getFormattedCountryName())
    }
}

struct CityAutocompletionResponseModel: Codable {
    var results: [City]
    var more: Bool
    var estimated_total: Int
}
