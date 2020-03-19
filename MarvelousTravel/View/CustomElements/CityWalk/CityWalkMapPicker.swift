//
//  CityWalkViewController.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/15/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit
import SHSearchBar
import GoogleMapsTileOverlay
import MapKit
import CoreLocation

class CityWalkMapPicker: UIViewController, SHSearchBarDelegate, CLLocationManagerDelegate {
    
    var searchBar: SHSearchBar!
    var rasterSize: CGFloat = 11.0
    var viewConstraints: [NSLayoutConstraint]?
    var currentLocation: CLLocation!
    var locationManager = CLLocationManager()

    let searchbarHeight: CGFloat = 44.0
    let viewModel = CityWalkViewModel()

    @IBOutlet weak var searchStackView: UIStackView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var createCityWalkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
                
        configureMap()
        configureLocationManager()
        
        let searchGlassIconTemplate = UIImage(named: "icon-search")!.withRenderingMode(.alwaysTemplate)

//        let leftView3 = imageViewWithIcon(searchGlassIconTemplate, rasterSize: 50)
        // create search bar
        searchBar = defaultSearchBar(withRasterSize: rasterSize,
                                      leftView: nil,
                                      rightView: nil,
                                      delegate: self)
        
        searchStackView.addArrangedSubview(searchBar)
        
        
        // set touch recognizers
        let touchRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToSearchScreen))
        searchBar.textField.isUserInteractionEnabled = false
        searchBar.addGestureRecognizer(touchRecognizer)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(reverseGeocodeLocation))
        mapView.addGestureRecognizer(longPressGestureRecognizer)
        
        // set button
        createCityWalkButton.isEnabled = false
        createCityWalkButton.addTarget(self, action: #selector(goToTimePicker), for: .touchUpInside)
        
        // set observers
        self.observe(for: viewModel.selectedItem, with: {
            value in
            if value != nil {
                self.createCityWalkButton.isEnabled = true
            } else {
                self.createCityWalkButton.isEnabled = false
            }
        })
        
        self.observe(for: viewModel.selectedItem, with: {
            value in
            if value != nil {
                self.centerMapForCoordinates(coordinate: value!.placemark.coordinate, animated: true)
            }
        })
    }
    
    func imageViewWithIcon(_ icon: UIImage, rasterSize: CGFloat) -> UIImageView {
        let imgView = UIImageView(image: icon)
        imgView.frame = CGRect(x: 0, y: 0, width: icon.size.width + rasterSize * 2.0, height: icon.size.height)

        imgView.contentMode = .center
        imgView.tintColor = .black
        return imgView
    }
    
    @objc func reverseGeocodeLocation(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: mapView)
            let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: touchCoordinate.latitude, longitude: touchCoordinate.longitude)
            geoCoder.reverseGeocodeLocation(location, completionHandler: {
                placemarks, error -> Void in
                guard let placeMark = placemarks?.first else { return }
                if let addressDict = placeMark.addressDictionary, let coordinate = placeMark.location?.coordinate {
                    let mkPlacemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict as? [String : Any])
                    self.viewModel.selectedItem.value = MKMapItem(placemark: mkPlacemark)
                }
                
            })
        }
    }
    
    func centerMapForCoordinates(coordinate: CLLocationCoordinate2D, animated: Bool) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Position selected"
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation) //drops the pin
        
        mapView.setCenter(coordinate, animated: animated) // move to center
    }
    
    func defaultSearchBar(withRasterSize rasterSize: CGFloat,
                          leftView: UIView?,
                          rightView: UIView?,
                          delegate: SHSearchBarDelegate,
                          useCancelButton: Bool = true) -> SHSearchBar {

        var config = defaultSearchBarConfig(rasterSize)
        config.leftView = leftView
        config.rightView = rightView
        config.useCancelButton = useCancelButton

        if leftView != nil {
            config.leftViewMode = .always
        }

        if rightView != nil {
            config.rightViewMode = .unlessEditing
        }

        let bar = SHSearchBar(config: config)
        bar.delegate = delegate
        bar.placeholder = "Find location"
        bar.updateBackgroundImage(withRadius: 6, corners: [.allCorners], color: UIColor.white)
        bar.layer.shadowColor = UIColor.black.cgColor
        bar.layer.shadowOffset = CGSize(width: 0, height: 3)
        bar.layer.shadowRadius = 5
        bar.layer.shadowOpacity = 0.25
        return bar
    }

    func defaultSearchBarConfig(_ rasterSize: CGFloat) -> SHSearchBarConfig {
        var config: SHSearchBarConfig = SHSearchBarConfig()
        config.rasterSize = rasterSize
    //    config.cancelButtonTitle = NSLocalizedString("sbe.general.cancel", comment: "")
        config.cancelButtonTextAttributes = [.foregroundColor: UIColor.darkGray]
        config.textContentType = UITextContentType.fullStreetAddress.rawValue
        config.textAttributes = [.foregroundColor: UIColor.gray]
        return config
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchScreenSegue" {
            if let searchScreenViewController = segue.destination as? SearchCompletionViewController {
                searchScreenViewController.viewModel = viewModel
            }
        }
        
        if segue.identifier == "timePickerSegue" {
           if let searchScreenViewController = segue.destination as? TimePickerViewController {
               searchScreenViewController.viewModel = viewModel
           }
        }
    }
    
    func configureMap() {
        mapView.showsUserLocation = true
        
        guard let jsonURL = Bundle.main.url(forResource: "redIsh", withExtension: "json") else { return }
        let tileOverlay = try? GoogleMapsTileOverlay(jsonURL: jsonURL)
        tileOverlay!.canReplaceMapContent = true
        mapView.addOverlay(tileOverlay!, level: .aboveRoads)
    }
    
    func configureLocationManager() {
        // setup location manager and get current location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 1000
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.startUpdatingLocation()
        
        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways)
        {
            currentLocation = locationManager.location
        }
        
        if CLLocationManager.headingAvailable()
        {
            locationManager.headingFilter = 5
            locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        // move to location once it is updated
        let location = locations.last! as CLLocation
        
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        
        let span = MKCoordinateSpan(latitudeDelta: 0.050, longitudeDelta: 0.050)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), span: span)
        mapView.setRegion(region, animated: false)
    }
    
    @objc func goToTimePicker() {
        performSegue(withIdentifier: "timePickerSegue", sender: nil)
    }
    
    @objc func goToSearchScreen() {
        performSegue(withIdentifier: "searchScreenSegue", sender: nil)
    }

}


extension CityWalkMapPicker: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // This is the final step. This code can be copied and pasted into your project
        // without thinking on it so much. It simply instantiates a MKTileOverlayRenderer
        // for displaying the tile overlay.
        if let tileOverlay = overlay as? MKTileOverlay {
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        } else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
