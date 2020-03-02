
//
//  MessageService.swift
//  SocketSample
//
//  Created by  Ilia Goncharenko on 2020-02-21.
//  Copyright © 2020 name. All rights reserved.
//

import Foundation

class MessageService {
    
    func sendMessage(message : Message, completion: @escaping (Error?) -> Void){
        let url = URL(string: "http://localhost:3000/api/chatMessages")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters : [String: Any] = [
            "chatId" : message.chatId,
            "userId" : message.userId,
            "messageBody" : message.messageBody,
            "date" : message.date
        ]
        
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: {(data, response, error) in
            
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let message = try jsonDecoder.decode(Message.self, from: data)
                    print(message)
                } catch {
                    print(error)
                }
            }
            
        }).resume()
    }
       
    
}
