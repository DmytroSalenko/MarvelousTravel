//
//  SocketManager.swift
//  SocketSample
//
//  Created by  Ilia Goncharenko on 2020-02-21.
//  Copyright © 2020 name. All rights reserved.
//

import Foundation
import SocketIO
import SwiftyJSON

class SocketIOManager : NSObject {
    static let sharedInstance = SocketIOManager()
    
    var socket : SocketIOClient!
    var socketManager:SocketManager!
    var newReceivedMessage = Message()
    
    override init() {
        super.init()
        socketManager = SocketManager(socketURL: URL(string: "http://localhost:3000")!)
        socket = socketManager.defaultSocket
        socketManager.setConfigs([.secure(false), .log(true), .compress])
        socket = socketManager.socket(forNamespace: "/")
        
        socket.connect(timeoutAfter: 15, withHandler: {
        print("")
        })
    }
    
    func establishConnection() {
        socket.connect()
        
        socket.on(clientEvent: .connect, callback: {data, ack in
            print("socket connected")
            self.socket.emit("join", with: ["Hello from client"] as! [Any])
            self.socket.on("message", callback: {data, ack in
                print(data)
            })
            self.socket.on("newChatMessage", callback: {data, ack in
                let messageDictionary = data[0] as! Dictionary<NSString,AnyObject>
                self.newReceivedMessage = self.convertDataToMessage(data: messageDictionary)
                NotificationCenter.default.post(name: NSNotification.Name("newChatMessageNotification"), object: self.newReceivedMessage)
            })
        })
    }
       
    func closeConnection() {
        socket.disconnect()
    }
    
    func convertDataToMessage(data : Dictionary<NSString,AnyObject>) -> Message{
        let message = Message()
        
        message.id = data["_id"] as! String
        message.userId = data["userId"] as! String
        message.messageBody = data["messageBody"] as! String
        message.date = data["date"] as! String
        message.chatId = data["chatId"] as! String

        return message
    }
    
}
