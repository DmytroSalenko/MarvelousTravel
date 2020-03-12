//
//  Destinations.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/12/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation

class Destination : Codable {
    var startDate : String?
    var endDate : String?
    var city : City?
    
    enum CodingKeys: String, CodingKey {
        case city
        case startDate = "start_date"
        case endDate = "end_date"
    }
    
    init(city: City, startDate: String, endDate: String) {
        self.city = city
        self.startDate = startDate
        self.endDate = endDate
    }
}
