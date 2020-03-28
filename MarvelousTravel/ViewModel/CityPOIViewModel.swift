//
//  CityPOIViewModel.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/5/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation
import UIKit

class PoiData {
    var label: String
    var isLoaded: Bool
    var poiData: [CityPoi]
    
    init(label: String, status: Bool) {
        self.label = label
        self.isLoaded = status
        self.poiData = []
    }
}

class CityPOIViewModel {
    let categorySelected: Observable<String>
    let locationId: Observable<String>
    let numberOfElementsToShow = 4
    let client = PoiService(config:URLSessionConfiguration.default)
    let categories = ["Popular", "Architecture", "Culture", "Parks", "Romantic", "Restaurants"] //TODO create ordered dict
    let categoryData: [String: PoiData] = [
        "Popular": PoiData(label: "", status: false),
        "Architecture": PoiData(label: "poitype-Arch|person_architect|architecture", status: false),
        "Culture": PoiData(label: "subtype-Archaeological_museums|subtype-Art_museums|poitype-Theatre", status: false),
        "Parks": PoiData(label: "poitype-Park", status: false),
        "Romantic": PoiData(label: "character-Romantic", status: false),
        "Restaurants": PoiData(label: "poitype-Restaurant", status: false)
    ]
    
    // flags
    let isLoading: Observable<Bool>
    let isLoaded: Observable<Bool>
    
    init() {
        locationId = Observable("New_York_City")
        categorySelected = Observable("Popular")
        isLoading = Observable(false)
        isLoaded = Observable(false)
    }
    
    func loadPoiOverviewDataForSelectedCategory(label: String, onCompletion: @escaping (Bool)->()) {
        var isUpdateRequired = false
        let data = categoryData[label]
        if !data!.isLoaded {
            let labelToSend = data!.label
            do {
                try client.loadPoiPreviewData(label: labelToSend, location: locationId.value!,
                     onSuccess: {
                       valuesReceived in
                        data!.poiData = valuesReceived
                        data!.isLoaded = true
                        isUpdateRequired = true
                        onCompletion(isUpdateRequired)
                     },
                     onError: {
                       error in
                        data!.isLoaded = false
                        self.isLoading.value = false
                        onCompletion(isUpdateRequired)
                     })
            } catch {
                data!.isLoaded = true
                self.isLoading.value = false
                onCompletion(isUpdateRequired)
            }
        } else {
            isUpdateRequired = true
            onCompletion(isUpdateRequired)
        }
    }
}
