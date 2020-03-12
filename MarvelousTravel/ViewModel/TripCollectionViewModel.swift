//
//  TripCollectionViewModel.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/10/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation

class TripCollectionViewModel {
    var tripArray = [Trip]()
    let client = TripService()
    
    // flags
    let isLoading: Observable<Bool>
    let isLoaded: Observable<Bool>
    
    init() {
        isLoading = Observable(false)
        isLoaded = Observable(false)
    }
    
    func loadTrips(completionHandler: @escaping(Bool)->()) {
        isLoading.value = true
        do {
            try client.getAllTrips(onSuccess: {
                trips in
                self.isLoaded.value = true
                self.isLoading.value = false
                self.tripArray.append(contentsOf: trips)
                completionHandler(true)
            }, onError: {
                error in
                self.isLoading.value = false
                completionHandler(false)
            })
        } catch {
            self.isLoading.value = false
            completionHandler(false)
        }
    }
}
