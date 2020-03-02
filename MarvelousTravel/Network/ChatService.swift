//
//  ChatServices.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/2/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation
import SwiftyJSON

class ChatService {
    
    func getSingleChat(completion : @escaping (Chat?, NSError?) -> Void) {
        
    guard let url = URL(string: "http://localhost:3000/api/chats/5e34bb82de34b31645b4ec9b") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
//        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {return}
       // request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                if let json = try? JSON(data: data) {
                   var chat = Chat()
                    chat.id = json["_id"].stringValue
                    chat.tripId = json["tripId"].stringValue
                    for item in json["chatMessages"].arrayValue {
                        var message = Message()
                        message.id = item["_id"].stringValue
                        message.userId = item["userId"].stringValue
                        message.messageBody = item["messageBody"].stringValue
                        message.date = item["date"].stringValue
                        message.chatId = item["chatId"].stringValue
                        chat.chatMessages.append(message)
                    }
                    completion(chat, nil)
                }
            }else {
                completion(nil, error as! NSError)
            }
        }.resume()
        
    }
    
    
    
}
