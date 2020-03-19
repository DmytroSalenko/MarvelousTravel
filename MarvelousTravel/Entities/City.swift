//
//  LocationModel.swift
//  SignInScreen
//
//  Created by Dmytro Salenko on 2/27/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation

class City: Codable, Equatable {
    var id: String?
    var parent_id: String?
    var country_id: String?
    var name: String?
    var snippet: String?
    var coordinates: Coordinates?
    var images: [CityImageMetaData]?
    
    static func == (lhs: City, rhs: City) -> Bool {
        return lhs.id == rhs.id && lhs.snippet == rhs.snippet && lhs.country_id == rhs.country_id && lhs.parent_id == rhs.parent_id && lhs.name == rhs.name
    }
    
    public func getFormatedName() -> String {
        return (name?.replacingOccurrences(of: "_", with: " "))!
    }
    
    public func getFormattedCountryName() -> String {
        return (country_id?.replacingOccurrences(of: "_", with: " "))!
    }
    
    public func getFormattedFullName() -> String {
        return String(format: "%@, %@", getFormatedName(), getFormattedCountryName())
    }
    
    public func getImagesUrl(size: ImageSize) -> [String?]{
        switch size {
            case .medium:
                return images.map({$0.map({$0.sizes?.medium?.url})}) ?? [String]()
            case .original:
                return images.map({$0.map({$0.sizes?.original?.url})}) ?? [String]()
            case .thumbnail:
                return images.map({$0.map({$0.sizes?.thumbnail?.url})}) ?? [String]()
        }
    }
    
    enum ImageSize {
        case medium
        case original
        case thumbnail
    }
}

struct CityAutocompletionResponseModel: Codable {
    var results: [City]
    var more: Bool
    var estimated_total: Int
}

struct CityImageMetaData: Codable {
    var caption: String?
    var sizes: CityImageSize?
    
    var dictionary: [String: Any] {
        return ["caption": caption,
                "sizes": sizes?.dictionary]
    }
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}

struct CityImageSize: Codable {
    var medium: CityImage?
    var original: CityImage?
    var thumbnail: CityImage?
    
    var dictionary: [String: Any] {
        return ["medium": medium?.dictionary,
                "original": original?.dictionary,
                "thumbnail": thumbnail?.dictionary]
    }
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}

struct CityImage: Codable {
    var url: String?
    var width: Int?
    var height: Int?
    var bytes: Int?
    var format: String?
    
    var dictionary: [String: Any] {
        return ["url": url,
                "width": width,
                "height": height,
                "bytes": bytes,
                "format":format]
    }
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}


//struct Json {
//    static let encoder = JSONEncoder()
//}
//
//extension Encodable {
//    subscript(key: String) -> Any? {
//        return dictionary[key]
//    }
//    var dictionary: [String: Any] {
//        return (try? JSONSerialization.jsonObject(with: Json.encoder.encode(self))) as? [String: Any] ?? [:]
//    }
//}
