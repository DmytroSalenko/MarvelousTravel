//
//  CitiesService.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/2/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation

class CitiesService {
    private var urlSession: URLSession
    private lazy var jsonDecoder = JSONDecoder()

    public init(config:URLSessionConfiguration) {
        urlSession = URLSession(configuration: config)
    }
    
    func citiesAutocompletionQuery(_ inputString: String, _ numberOfItems: Int = 3, onSuccess: @escaping ([City])->(), onError: @escaping (Error?) -> ()) {
        // rework
        var components = URLComponents(string:"https://www.triposo.com/api/20180627/location.json")!
        components.queryItems = [
            URLQueryItem(name: "tag_labels", value: "city"),
            URLQueryItem(name: "annotate", value: "trigram:\(inputString)"),
            URLQueryItem(name: "trigram", value: ">=0.3"),
            URLQueryItem(name: "count", value: "\(numberOfItems)"),
            URLQueryItem(name: "fields", value: "id,name,score,country_id,parent_id,snippet,images"),
            URLQueryItem(name: "order_by", value: "-trigram"),
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
                        let objs = try self.jsonDecoder.decode(CityAutocompletionResponseModel.self, from: _data)
                        onSuccess(objs.results)
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
