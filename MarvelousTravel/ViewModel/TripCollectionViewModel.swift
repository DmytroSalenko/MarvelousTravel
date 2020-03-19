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
    var stockPhotoArray = [String?]()
    let client = TripService()
    let cityClient = CitiesService(config: URLSessionConfiguration.default)
    
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
                self.stockPhotoArray = Array(repeating: nil, count: self.tripArray.count)
                self.downloadStockPhotoUrls({
                    completionHandler(true)
                })
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
    
    func downloadStockPhotoUrls(_ onComplete: @escaping()->()) {
        let requestGroup = DispatchGroup()
        for (index, trip) in tripArray.enumerated() {
            requestGroup.enter()
            let destinations = trip.destinations
            let firstCity = destinations.first!.city!.name
            do {
                try cityClient.getStockImage(forCity: firstCity!, onSuccess: {
                    image in
                    self.stockPhotoArray[index] = image.medium
                    requestGroup.leave()
                }, onError: {
                    error in
                     self.stockPhotoArray[index] = nil
                    requestGroup.leave()
                })
            } catch {
                self.stockPhotoArray[index] = nil
                requestGroup.leave()
            }
        }
        requestGroup.notify(queue: .main) {
            onComplete()
        }
    }
}
