//
//  CityWalkService.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/17/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation


class CityWalkService {
    private var urlSession: URLSession
    private lazy var jsonDecoder = JSONDecoder()

    public init(config:URLSessionConfiguration = URLSessionConfiguration.default) {
        urlSession = URLSession(configuration: config)
    }
    
    func sendCityWalkRequest(location: String, totalTime: Int, latitude: Double, longitude: Double, onSuccess: @escaping ([CityWalkResults]) -> (), onError: @escaping (Error?) -> ()) throws {
        var components = URLComponents(string:"https://www.triposo.com/api/20190906/city_walk.json")!
        components.queryItems = [
            URLQueryItem(name: "location_id", value: location),
            URLQueryItem(name: "total_time", value: "\(totalTime)"),
            URLQueryItem(name: "latitude", value: "\(latitude)"),
            URLQueryItem(name: "longitude", value: "\(longitude)"),
            URLQueryItem(name: "optimal", value: "true"),
            URLQueryItem(name: "account", value: "60V4HGIQ"),
            URLQueryItem(name: "token", value: "224lunxhzsjtnlt0jw7n30yhgebkre1h"),
        ]
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        
        let task = self.urlSession.dataTask(with: request) {
            (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                do {
                    let _data = data ?? Data()
                    if (200...399).contains(statusCode) {
                        let objs = try self.jsonDecoder.decode(CityWalkResponse.self, from: _data)
                        onSuccess(objs.results!)
                    } else {
                        onError(error)
                    }
                } catch {
                    onError(error)
                }
            }
        }
        task.resume()
    }
    
}
