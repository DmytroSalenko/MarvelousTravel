//
//  DestinationSearchViewModel.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/24/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation

enum SearchBarState {
    case up, down
}

class DestinationSearchViewModel {
    let topCities = ["Amsterdam", "Bangkok", "Dubai", "London", "Madrid", "Paris", "Prague", "Rome", "Tokyo", "Vancouver"]
    let currentCityIndexPath: Observable<IndexPath>
    let searchBarState: Observable<SearchBarState>
    
    init() {
        searchBarState = Observable(.down)
        currentCityIndexPath = Observable(IndexPath(row: 0, section: 0))
    }
}
