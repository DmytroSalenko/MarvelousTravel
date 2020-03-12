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
    var sizes: CityImageData?
}

struct CityImageData: Codable {
    var medium: CityImage?
    var original: CityImage?
    var thumbnail: CityImage?
}

struct CityImage: Codable {
    var url: String?
    var width: Int?
    var height: Int?
    var bytes: Int?
    var format: String?
}
