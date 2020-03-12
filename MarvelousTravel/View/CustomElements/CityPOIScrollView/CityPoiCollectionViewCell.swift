//
//  CityPoiCollectionViewCell.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/7/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit

class CityPoiCollectionViewCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var poiNameLabel: UILabel!
    @IBOutlet weak var poiAddressLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var poiPhotosCollectionView: UICollectionView!
    var poiImages = [PoiImage]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let cityPoiImageNib = UINib(nibName: CityPoiImageCell.nibName, bundle: nil)
        poiPhotosCollectionView?.register(cityPoiImageNib, forCellWithReuseIdentifier: CityPoiImageCell.reuseIdentifier)
    }
    
    class var reuseIdentifier: String {
        return "CityPOICollectionViewCellIdentifier"
    }

    class var nibName: String {
        return "CityPoiCollectionViewCell"
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = poiPhotosCollectionView.bounds.size
        return CGSize(width: size.height, height: size.height)
    }
    
    func configureCell(poi: CityPoi) {
        poiImages = poi.images ?? []
        poiPhotosCollectionView.reloadData()
        
        let poiName = poi.name
        let poiCity = poi.location_id
        poiNameLabel.text = "\(poiName!), \(poiCity!)"
    }
}


extension CityPoiCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return poiImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (poiPhotosCollectionView.dequeueReusableCell(withReuseIdentifier: CityPoiImageCell.reuseIdentifier, for: indexPath) as? CityPoiImageCell)!
        
        let imageData = poiImages[indexPath.row]
        let imageUrlString = imageData.sizes?.medium?.url
        if imageUrlString != nil {
            cell.configureCell(imageUrl: URL(string: imageUrlString!)!)
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
        } else {
            cell.backgroundColor = .white
        }
        return cell
    }
}

