//
//  Trip.swift
//  SocketSample
//
//  Created by  Ilia Goncharenko on 2020-02-28.
//  Copyright © 2020 name. All rights reserved.
//

import Foundation

//class Trip : Codable {
//    var name : String?
//    var description : String?
//    var startDate : String?
//    var endDate : String?
//    var pictureURL : String?
//}

class Trip : Codable {
    var userId : String?
    var name : String?
    var description : String?
    var trip_start_date : String?
    var trip_end_date : String?
    var pictureURL : String?
    var destinations = [Destination]()
}


