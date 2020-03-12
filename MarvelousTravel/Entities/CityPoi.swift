//
//  CityPoi.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/5/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation
import UIKit

struct Coordinates: Codable {
    var latitude: Double?
    var longitude: Double?
}

struct PoiImage: Codable {
    var caption: String?
    var sizes: PoiImageSizes?
    var source_url: String?
}

struct PoiImageSizes: Codable {
    var medium: PoiImageSize?
    var original: PoiImageSize?
    var thumbnail: PoiImageSize?
}

struct PoiImageSize: Codable {
    var url: String?
    var width: Int?
    var format: String?
    var bytes: Int?
    var height: Int?
}

class CityPoi: Codable {
    var id: String?
    var name: String?
    var coordinates: Coordinates?
    var images: [PoiImage]?
    var snippet: String?
    var intro: String?
    var location_id: String?
}

class CityPoiResponseData: Codable {
    var results: [CityPoi]?
    var more: Bool?
}
