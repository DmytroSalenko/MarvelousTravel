//
//  CityWalkViewModel.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/16/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation
import MapKit

class CityWalkViewModel {
    var matchingItems: [MKMapItem] = []
    var selectedItem: Observable<MKMapItem?>
    var walkDuration: Int?
    var generatedCityWalkResult: CityWalkResults?
    var cityWalkWayPoints = [CityWalkWaypoint]()
    
    let client = CityWalkService()
    
    // flags
    let isLoading: Observable<Bool>
    let isLoaded: Observable<Bool>
    
    init() {
        selectedItem = Observable(nil)
        isLoading = Observable(false)
        isLoaded = Observable(false)
    }
    
    func updateSearchResultsForSearchController(searchBarText: String, completionHandler: @escaping(Bool)->()) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                completionHandler(false)
                return
            }
            self.matchingItems = response.mapItems
            completionHandler(true)
        }
    }
    
    func generateCityWalk(completionHandler: @escaping(Bool)->()) {
        guard let location = selectedItem.value??.placemark.locality else {return}
        guard let latitude = selectedItem.value??.placemark.coordinate.latitude else {return}
        guard let longitude = selectedItem.value??.placemark.coordinate.longitude else {return}
        isLoading.value = true
        do {
            try client.sendCityWalkRequest(location: location, totalTime: walkDuration!, latitude: latitude, longitude: longitude, onSuccess: {
                values in
                self.generatedCityWalkResult = values.first
                self.cityWalkWayPoints = Array(self.generatedCityWalkResult?.way_points?[1...] ?? [])
                self.isLoading.value = false
                self.isLoaded.value = true
                completionHandler(true)
            }, onError: {
                error in
                self.isLoading.value = false
                self.isLoaded.value = false
                completionHandler(false)
            })
        } catch {
            self.isLoading.value = false
            self.isLoaded.value = false
            completionHandler(false)
        }
    }
}


