//
//  StockImage.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/13/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation

struct StockPhotoResponse: Codable {
    var total_results: Int?
    var page: Int?
    var per_page: Int?
    var photos: [StockPhotoMeta]?
}

struct StockPhotoMeta: Codable {
    var id: Int?
    var width: Int?
    var height: Int?
    var url: String?
    var src: StockPhotoUrl?
}

struct StockPhotoUrl: Codable {
    var original: String?
    var large2x: String?
    var medium: String?
    var small: String?
    var portrait: String?
    var landscape: String?
    var tiny: String?
}

enum StockPhotoSize: String {
    case original = "original"
    case large2x = "large2x"
    case medium = "medium"
    case small = "small"
    case portrait = "portrait"
    case landscape = "landscape"
    case tiny = "tiny"
}
