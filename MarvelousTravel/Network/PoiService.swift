//
//  PoiService.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/5/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation

class PoiService {
    private var urlSession: URLSession
    private lazy var jsonDecoder = JSONDecoder()

    public init(config:URLSessionConfiguration) {
        urlSession = URLSession(configuration: config)
    }
    
    func loadPoiPreviewData(label: String, location: String, count: Int = 4, offset: Int = 0, onSuccess: @escaping ([CityPoi]) -> (), onError: @escaping (Error?) -> ()) throws {
        var components = URLComponents(string:"https://www.triposo.com/api/20190906/poi.json")!
        components.queryItems = [
            URLQueryItem(name: "location_id", value: location),
            URLQueryItem(name: "count", value: "\(count)"),
            URLQueryItem(name: "fields", value: "images,id,name,snippet,coordinates,intro,location_id"),
            URLQueryItem(name: "order_by", value: "-score"),
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "account", value: "60V4HGIQ"),
            URLQueryItem(name: "token", value: "224lunxhzsjtnlt0jw7n30yhgebkre1h"),
        ]
        if label != "" {
            components.queryItems?.append(URLQueryItem(name: "tag_labels", value: label))
        }
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        
        let task = self.urlSession.dataTask(with: request) {
            (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                do {
                    let _data = data ?? Data()
                    if (200...399).contains(statusCode) {
                        let objs = try self.jsonDecoder.decode(CityPoiResponseData.self, from: _data)
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
    
    func fetchImage(_ urlString: String, completionHandler: @escaping(_ data: Data?)->()) {
        let url = URL(string: urlString)
        
        let dataTask = self.urlSession.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("Error fetching the image!")
                completionHandler(nil)
            } else {
                completionHandler(data)
            }
        }
            
        dataTask.resume()
    }
}
