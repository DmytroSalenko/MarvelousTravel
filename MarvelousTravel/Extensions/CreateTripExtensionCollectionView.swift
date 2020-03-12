//
//  CreateTripExtensionCollectionView.swift
//  MarvelousTravel
//
//  Created by  Ilia Goncharenko on 2020-03-10.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation
import UIKit

extension CreateTripViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return destinationsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = destinationsCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! DestinationCollectionViewCell
        let destination = trip.destinations[indexPath.row]
        guard let country = destination.city?.getFormattedCountryName(), let city = destination.city?.getFormatedName(), let startDate = destination.startDate, let endDate = destination.endDate else {return cell}
        cell.displayContent(country: country, city: city, startDate: startDate, endDate: endDate)
        return cell
    }
    
}
