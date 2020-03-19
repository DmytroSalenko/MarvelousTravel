//
//  CityWalk.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/17/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation

class CityWalkResponse: Codable {
    var results: [CityWalkResults]?
    var more: Bool?
}

class CityWalkResults: Codable {
    var walk_distance: Int?
    var walk_duration: Int?
    var total_duration: Int?
    var seed: Int?
    var way_points: [CityWalkWaypoint]?
}

class CityWalkWaypoint: Codable {
    var poi: CityPoi?
    var coordinates: Coordinates?
    var visit_time: Int?
    var walk_to_next_distance: Int?
    var walk_to_next_duration: Int?
}
