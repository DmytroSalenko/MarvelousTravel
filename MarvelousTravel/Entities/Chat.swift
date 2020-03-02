//
//  Chat.swift
//  SocketSample
//
//  Created by  Ilia Goncharenko on 2020-02-21.
//  Copyright © 2020 name. All rights reserved.
//

import Foundation

class Chat : Codable {
    var id : String?
    var name : String?
    var tripId : String?
    var pictureUrl : String?
    var chatMessages = [Message]()
}
