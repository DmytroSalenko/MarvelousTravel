//
//  GridViewCell.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 20/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import UIKit
import MapKit

final class GridViewCell: UITableViewCell {

    var dataSource: CityWalkWaypoint?
    
    @IBOutlet var stackView: UIStackView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
    }
    
    class var nibName: String {
        return "GridViewCell"
    }
    
    class var reuseIdentifier: String {
        return "gridViewCell"
    }
    
    func configureCell() {
        setImages()
        setMap()
    }
    
    func setImages() {
        let cityPoi = dataSource!.poi
        var poiImagesArray = [String]()
        
        for image in cityPoi!.images! {
            let imageUrlString = image.sizes!.medium!.url
            
            poiImagesArray.append(imageUrlString!)
        }
        for case let imageView as UIImageView in stackView.arrangedSubviews {
            if poiImagesArray.count > 0 {
                let randomIndex = Int.random(in: 0..<poiImagesArray.count)
                let randomImageUrl = poiImagesArray[randomIndex]
                imageView.sd_imageTransition = .fade
                imageView.sd_setImage(with: URL(string: randomImageUrl)!)
                poiImagesArray.remove(at: randomIndex)
            }
        }
    }
    
    func setMap() {
        mapView.isUserInteractionEnabled = false
        mapView.showsUserLocation = true
        guard let latitude = dataSource?.coordinates?.latitude else {return}
        guard let longitude = dataSource?.coordinates?.longitude else {return}
        
        let mapCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion( center: mapCoordinates, latitudinalMeters: CLLocationDistance(exactly: 3000)!, longitudinalMeters: CLLocationDistance(exactly: 3000)!)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapCoordinates
        mapView.addAnnotation(annotation)
        mapView.setCenter(mapCoordinates, animated: false)
        mapView.setRegion(mapView.regionThatFits(region), animated: false)

    }
}
