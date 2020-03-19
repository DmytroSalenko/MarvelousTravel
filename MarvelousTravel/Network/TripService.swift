//
//  TripService.swift
//  SocketSample
//
//  Created by  Ilia Goncharenko on 2020-02-28.
//  Copyright © 2020 name. All rights reserved.
//

import Foundation
class TripService {

    private lazy var jsonDecoder = JSONDecoder()
    
    func createTrip(trip : Trip, destinationsArray: [Any], completion: @escaping (Error?) -> Void){
        let url = URL(string: "http://localhost:3000/api/trips")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        

        let parameters : [String: Any] = [
            "creator" : "5e39f1743c545b2ce181f20d", // TODO refactor to add the user id stored after login
            "name" : trip.name,
            "description" : trip.description,
            "trip_start_date" : trip.trip_start_date,
            "trip_end_date" : trip.trip_end_date,
            "picture_url" : trip.pictureURL,
            "destinations" : destinationsArray
        ]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: {(data, response, error) in
            
            if let data = data {
                print(data)
                do {
                    let jsonDecoder = JSONDecoder()
                    let trip = try jsonDecoder.decode(Trip.self, from: data)
                    trip.destinations.forEach { (destination) in
                        print(destination.city?.name)
                    }
                } catch {
                    print(error)
                }
            }
            
        }).resume()
    }
    
    func getAllTrips(onSuccess: @escaping ([Trip])->(), onError: @escaping (Error?)->()) throws {
        var request = URLRequest(url: URL(string:"http://localhost:3000/api/trips")!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                do {
                    let _data = data ?? Data()
                    if (200...399).contains(statusCode) {
                        let objs = try self.jsonDecoder.decode([Trip].self, from: _data)
                        onSuccess(objs)
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
