//
//  CityPOIDetailedViewController.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/7/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit
import MapKit
import GoogleMapsTileOverlay

class CityPOIDetailedViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var poiCollectionView: UICollectionView!
    let viewModel = CityPOIDetailedViewModel()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        mapView.delegate = self
        configureMap()
        
        if viewModel.poiData.count != 0 {
        poiCollectionView.decelerationRate = .normal
            let numberOfElementsToAppend = 4
            let startIndex = 4
            viewModel.appendPoiData(count: numberOfElementsToAppend, offset: startIndex, completionHandler: {
                status in
                if status {
                    let indexToInsert = self.viewModel.poiData.count - numberOfElementsToAppend
                    DispatchQueue.main.async {
                        self.extendCollectionView(startIndex: indexToInsert, count: numberOfElementsToAppend)
                    }
                }
            })
        centerMapForIndexPath(viewModel.currentPoiIndexPath, animated: false)
        } else {
            let numberOfElementsToAppend = 8
            viewModel.appendPoiData(count: numberOfElementsToAppend, completionHandler: {
                status in
                if status {
                    DispatchQueue.main.async {
                        self.poiCollectionView.reloadData()
                    }
                }
            })
        }
    }
    
    func registerNib() {
        let cityPoiNib = UINib(nibName: CityPoiCollectionViewCell.nibName, bundle: nil)
        poiCollectionView?.register(cityPoiNib, forCellWithReuseIdentifier: CityPoiCollectionViewCell.reuseIdentifier)
    }
    
    func extendCollectionView(startIndex: Int, count: Int) {
        var indexPathArray = [IndexPath]()
        for i in 0 ..< count {
            indexPathArray.append(IndexPath(row: startIndex + i, section: 0))
        }
        poiCollectionView.insertItems(at: indexPathArray)
    }
    
    func configureMap() {
        let location = CLLocation(latitude: 39.818249, longitude: -86.152995)
        let region = MKCoordinateRegion( center: location.coordinate, latitudinalMeters: CLLocationDistance(exactly: 3000)!, longitudinalMeters: CLLocationDistance(exactly: 3000)!)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
        
        guard let jsonURL = Bundle.main.url(forResource: "minimal", withExtension: "json") else { return }
        let tileOverlay = try? GoogleMapsTileOverlay(jsonURL: jsonURL)
        tileOverlay!.canReplaceMapContent = true
        mapView.addOverlay(tileOverlay!, level: .aboveRoads)
    }
    
    func getVisibleCell() -> IndexPath? {
        let visiblePaths = poiCollectionView.indexPathsForVisibleItems
        let visiblePathsSorted = visiblePaths.sorted(by: {$0.row < $1.row})
        if visiblePaths.count == 3 {
            // there are 3 visible elements, one fully visible and the edges of
            // left and right. We need the one in the middle
            return visiblePathsSorted[1]
        } else {
            // private case when the fully visible element is either the first one or the last one
            return visiblePathsSorted[0]
        }
    }
    
    func centerMapForIndexPath(_ indexPath: IndexPath, animated: Bool = true) {
        let poiData = viewModel.poiData[indexPath.row]
        let poiCoordinatesValues = poiData.coordinates
        let mapCoordinates = CLLocationCoordinate2D(latitude: (poiCoordinatesValues?.latitude)!, longitude: (poiCoordinatesValues?.longitude)!)
        // remove old annotation
        mapView.removeAnnotations(mapView.annotations)
        // add new annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapCoordinates
        mapView.addAnnotation(annotation)
        mapView.setCenter(mapCoordinates, animated: animated)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if (translation.x < 0) {
            viewModel.currentPoiIndexPath.row += 1
            if viewModel.currentPoiIndexPath.row % 4 == 0  &&
                (viewModel.poiData.count - viewModel.currentPoiIndexPath.row) <= 4 {
                let numberOfElementsToAppend = 4
                let offset = viewModel.poiData.count
                viewModel.appendPoiData(count: numberOfElementsToAppend, offset: offset, completionHandler: {
                    status in
                    if status {
                        let startIndex = self.viewModel.poiData.count - numberOfElementsToAppend
                        DispatchQueue.main.async {
                            self.extendCollectionView(startIndex: startIndex, count: numberOfElementsToAppend)
                        }
                    }
                })
            }
        } else {
            if viewModel.currentPoiIndexPath.row != 0 {
                viewModel.currentPoiIndexPath.row -= 1
            }
        }
        poiCollectionView.scrollToItem(at: viewModel.currentPoiIndexPath, at: .centeredHorizontally, animated: true)
        centerMapForIndexPath(viewModel.currentPoiIndexPath)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        poiCollectionView.scrollToItem(at: viewModel.currentPoiIndexPath, at: .centeredHorizontally, animated: true)
    }
    
}

extension CityPOIDetailedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.poiData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityPoiCollectionViewCell.reuseIdentifier, for: indexPath) as? CityPoiCollectionViewCell {

            let poiData = viewModel.poiData[indexPath.row]
            cell.configureCell(poi: poiData)
            
            cell.layer.cornerRadius = 6
            cell.layer.masksToBounds = false
            cell.layer.shadowOffset = CGSize(width:0, height:1.0)
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.6
            cell.layer.shadowRadius = 4
            cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).cgPath
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension CityPOIDetailedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell: CityPoiCollectionViewCell = Bundle.main.loadNibNamed(CityPoiCollectionViewCell.nibName,
                                     owner: self,
                                     options: nil)?.first as? CityPoiCollectionViewCell else {
            return CGSize.zero
        }
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: 380, height: 300)
    }
}

extension UICollectionView {
    func snapToCell(velocity: CGPoint, targetOffset: UnsafeMutablePointer<CGPoint>, contentInset: CGFloat = 0, spacing: CGFloat = 0) {

        // No snap needed as we're at the end of the scrollview
        guard (contentOffset.x + frame.size.width) < contentSize.width else { return }
        guard let indexPath = indexPathForItem(at: targetOffset.pointee) else { return }
        guard let cellLayout = layoutAttributesForItem(at: indexPath) else { return }

        var offset = targetOffset.pointee

        if velocity.x < 0 {
            offset.x = cellLayout.frame.minX - max(contentInset, spacing)
        } else {
            offset.x = cellLayout.frame.maxX - contentInset + min(contentInset, spacing)
        }

        targetOffset.pointee = offset
    }
}


extension CityPOIDetailedViewController: MKMapViewDelegate {
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

