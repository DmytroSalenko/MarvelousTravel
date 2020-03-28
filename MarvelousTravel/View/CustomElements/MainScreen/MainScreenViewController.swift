//
//  MainScreenViewController.swift
//  MarvelousTravel
//
//  Created by Dmytro Salenko on 3/25/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit

class MainScreenViewController: UIViewController {

    @IBOutlet weak var videoOverlayView: UIView!
    @IBOutlet weak var videoContainerView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var mainScreenScrollView: UIScrollView!
    @IBOutlet weak var backgroundBlurEffectView: UIVisualEffectView!
    
    var destinationSearchView: DestinationSearchView?
    var player: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        destinationSearchView = destinationSearchViewSetupAndLoad()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let videoURL = Bundle.main.url(forResource: "TravelCompilation", withExtension: "mp4")!
        player = AVPlayer(url: videoURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        videoOverlayView.layer.addSublayer(playerLayer)
        player.play()

        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { [weak self] _ in
            self?.player?.seek(to: CMTime.zero)
            self?.player?.play()
        }
//        loadVideo()
    }
    
//    func loadVideo() {
//        let videoURL = Bundle.main.url(forResource: "CloudsBackground", withExtension: "mp4")!
//        player = AVPlayer(url: videoURL)
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = self.view.bounds
//        videoContainerView.layer.addSublayer(playerLayer)
//        player.play()
//
//        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { [weak self] _ in
//            self?.player?.seek(to: CMTime.zero)
//            self?.player?.play()
//        }
//    }
    
    func destinationSearchViewSetupAndLoad() -> DestinationSearchView {
        let destinationSearchView = DestinationSearchView(frame: mainScreenScrollView.bounds)
        destinationSearchView.translatesAutoresizingMaskIntoConstraints = false
        
        self.observe(for: destinationSearchView.viewModel.currentCityIndexPath) {
            cityPath in
            let row = cityPath.row
            let cityName = destinationSearchView.viewModel.topCities[row]
            let image = UIImage(named: cityName)!

            UIView.transition(with: self.backgroundImageView,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: { self.backgroundImageView.image = image },
            completion: nil)
        }
        
        self.observe(for: destinationSearchView.viewModel.searchBarState) {
            value in
            switch value {
            case .up:
                self.videoContainerView.isHidden = true
                self.videoOverlayView.isHidden = true
                self.backgroundImageView.isHidden = false
                self.backgroundBlurEffectView.isHidden = false
            case .down:
                self.videoContainerView.isHidden = false
                self.videoOverlayView.isHidden = false
                self.backgroundImageView.isHidden = true
                self.backgroundBlurEffectView.isHidden = true
            }
            
        }
        
        mainScreenScrollView.addSubview(destinationSearchView)
        return destinationSearchView
    }

}
