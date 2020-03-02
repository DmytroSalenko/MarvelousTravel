//
//  Message.swift
//  SocketSample
//
//  Created by  Ilia Goncharenko on 2020-02-21.
//  Copyright © 2020 name. All rights reserved.
//

import Foundation

class Message : Codable {
    var id : String?
    var userId : String?
    var userName : String?
    var messageBody : String?
    var date : String?
    var chatId : String?
}
