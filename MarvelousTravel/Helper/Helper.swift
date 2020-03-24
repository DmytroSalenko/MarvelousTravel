//
//  Helper.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/12/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation

class Helper {
    
    static func createDestinationDicionary(destination : Destination) -> [String : Any] {
        let mapDict = ["city" :
                            ["name" : destination.city!.name,
                             "parent_id" : destination.city!.parent_id,
                             "country_id" : destination.city!.country_id,
                             "images": destination.city!.images!.map({$0.nsDictionary}),
                             "coordinates": destination.city!.coordinates!.nsDictionary],
                       "start_date" : destination.startDate,
                       "end_date" : destination.endDate,] as [String : Any]
        return mapDict
    }
}
