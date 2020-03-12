//
//  CityPOIDetailedViewModel.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/7/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation


class CityPOIDetailedViewModel {
    var poiData = [CityPoi]()
    var currentPoiIndexPath: IndexPath
    
    var label: String
    var locationId: String
    
    let client = PoiService(config: URLSessionConfiguration.default)
    
    // flags
    let isLoading: Observable<Bool>
    
    init() {
        currentPoiIndexPath = IndexPath(row: 0, section: 0)
        isLoading = Observable(false)
        label = ""
        locationId = ""
    }
    
    
    func appendPoiData(count: Int = 4, offset: Int = 0, completionHandler: ((Bool)->())? = nil) {
        isLoading.value = true
        do {
            try client.loadPoiPreviewData(label: label, location: locationId, count: count, offset: offset, onSuccess: {
                values in
                self.isLoading.value = false
                self.poiData.append(contentsOf: values)
                if completionHandler != nil {
                    completionHandler!(true)
                }
            }, onError: {
                error in
                self.isLoading.value = false
                if completionHandler != nil {
                    completionHandler!(false)
                }
            })
        } catch {
            self.isLoading.value = false
            if completionHandler != nil {
                completionHandler!(false)
            }
        }
    }
    
}
