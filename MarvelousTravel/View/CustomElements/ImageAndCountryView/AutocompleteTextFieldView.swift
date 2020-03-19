//
//  CityAutocompleteViewModel.swift
//  SignInScreen
//
//  Created by Dmytro Salenko on 2/27/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation

class AutocompleteSearchTextFieldViewModel {
    let resultsList: Observable<[City]>
    let selectedCity: Observable<City?>
    
    // flags
    let isSelected: Observable<Bool>
    
    let client = CitiesService(config: URLSessionConfiguration.default)
    
    init() {
        resultsList = Observable([City]())
        selectedCity = Observable(nil)
        isSelected = Observable(false)
    }
    
    func getSuggestedCitiesList(_ inputString: String) {
        client.citiesAutocompletionQuery(inputString, onSuccess: {
            results in
            self.resultsList.value = results
        }, onError: {
            erorr in
            self.resultsList.value = []
        })
    }
}
