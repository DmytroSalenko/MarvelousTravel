//
//  MessageExtension.swift
//  SocketSample
//
//  Created by  Ilia Goncharenko on 2020-02-21.
//  Copyright © 2020 name. All rights reserved.
//

import Foundation
import MessageKit

extension Message : MessageType {
    var sender : SenderType {
        
        return Sender(senderId: userId ?? "Not defined", displayName: userName ?? "Not defined")
    }
    
    var messageId : String {
        return id!
    }
    
    var sentDate : Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.date(from: (date)!)!
    }
    
    var kind : MessageKind {
        return .text(messageBody!)
    }
}
