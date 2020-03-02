//
//  TripService.swift
//  SocketSample
//
//  Created by  Ilia Goncharenko on 2020-02-28.
//  Copyright © 2020 name. All rights reserved.
//

import Foundation

class TripService {
    
    func createTrip(trip : Trip, completion: @escaping (Error?) -> Void){
        let url = URL(string: "http://localhost:3000/api/trips")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters : [String: Any] = [
            "name" : trip.name,
            "description" : trip.description,
            "start_date" : trip.startDate,
            "end_date" : trip.endDate
        ]
        
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: {(data, response, error) in
            
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let message = try jsonDecoder.decode(Trip.self, from: data)
                    print(message)
                } catch {
                    print(error)
                }
            }
            
        }).resume()
    }
    
    
}
