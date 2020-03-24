//
//  ViewController.swift
//  SignInScreen
//
//  Created by Dmytro Salenko on 2/9/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit
import AVKit

class LoginScreenViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var swipeButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backgroundEffect: UIVisualEffectView!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var swipeButtonBottomConstraint: NSLayoutConstraint!
    
    var loginView: LoginView?
    var userDataView: UserAccountDataView?
    var imageAndCountryView: UserPersonalDataView?
    var player: AVPlayer!
    
    var mask: CALayer!
    var animation: CABasicAnimation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backgroundEffect.effect = nil
        
        let image = UIImage(named: "LogoLetter")!
        animateLaunch(image: image, bgColor: .red)
        
        loginView = logInScreenSetupAndLoad()
        userDataView = userAccountDataScreenSetupAndLoad()
        imageAndCountryView = userProfileDataViewSetupAndLoad()
        
        setScrollViewConstraints()
        
        configSwipeButton()
        configureContainerView()
        
        // add possibility to call login screen by swiping on empty space.
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(revealLoginWindow))
        swipeUp.direction = .up
        backgroundEffect.addGestureRecognizer(swipeUp)
        
        // set up notifications for keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        let videoURL = Bundle.main.url(forResource: "CloudsBackground", withExtension: "mp4")!
//        player = AVPlayer(url: videoURL)
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = self.view.bounds
//        backgroundView.layer.addSublayer(playerLayer)
//        player.play()
//
//        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { [weak self] _ in
//            self?.player?.seek(to: CMTime.zero)
//            self?.player?.play()
//        }
//    }
    
    func setScrollViewConstraints() {
        let views: [String: UIView] = ["view": scrollView, "loginView": self.loginView!, "userDataView": self.userDataView!, "imageAndCountryView": self.imageAndCountryView!]
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[loginView(==view)]|", options: [], metrics: nil, views: views)
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[loginView(==view)][userDataView(==view)][imageAndCountryView(==view)]|", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: views)
        NSLayoutConstraint.activate(verticalConstraints + horizontalConstraints)
    }
    
    func logInScreenSetupAndLoad() -> LoginView {
        let loginView = LoginView(frame: scrollView.bounds)
        loginView.translatesAutoresizingMaskIntoConstraints = false
        
        self.observe(for: loginView.isTransitionRequested) {
            value in
            if value {
                self.scrollToUserAccountDataPage()
            }
        }
        
        self.observe(for: loginView.isLogInSuccessful) {
            value in
            if value {
                self.goToMainScreen()
            }
        }
        
        scrollView.addSubview(loginView)
        return loginView
    }
    
    func userAccountDataScreenSetupAndLoad() -> UserAccountDataView {
        let userDataView = UserAccountDataView(frame: scrollView.bounds)
        userDataView.translatesAutoresizingMaskIntoConstraints = false
        
        self.observe(for: userDataView.isResetRequested) {
            value in
            if value {
                self.cancelRegistration()
            }
        }
        
        self.observe(for: userDataView.isTransitionRequested) {
            value in
            if value {
                self.scrollToImageAndCountryPickerView()
            }
        }
        
        scrollView.addSubview(userDataView)
        return userDataView
    }
    
    func configSwipeButton() {

        applyLoopedAnimationToButton()
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(revealLoginWindow))
        swipeUp.direction = .up
        swipeButton.addGestureRecognizer(swipeUp)
        swipeButton.addTarget(self, action: #selector(revealLoginWindow), for: .touchUpInside)
    }
    
    func configureContainerView() {
        containerView.alpha = 0
        containerBottomConstraint.constant += containerView.frame.height / 2
//        containerView.layoutIfNeeded()
        containerView.layer.cornerRadius = 25
        containerView.layer.masksToBounds = true
        
        containerView.layer.shadowRadius = 10
        containerView.layer.shadowColor = UIColor.black.cgColor
    }
    
    
    @objc func appMovedToBackground() {
       applyLoopedAnimationToButton()
    }
    
    func applyLoopedAnimationToButton() {
        UIView.animate(withDuration: 2.0, delay: 1.0, options: [UIView.AnimationOptions.repeat, .autoreverse, .allowUserInteraction], animations: {
                   self.swipeButton.center.y += self.swipeButton.bounds.height / 4
           })
    }
    
    func userProfileDataViewSetupAndLoad() -> UserPersonalDataView {
        let imageAndCountryView = UserPersonalDataView(frame: scrollView.bounds)
        imageAndCountryView.translatesAutoresizingMaskIntoConstraints = false
        
        // set observers
        self.observe(for: imageAndCountryView.isImagePickRequested) {
            value in
            if value {
                self.pickImage()
            }
        }
        
        scrollView.addSubview(imageAndCountryView)
        return imageAndCountryView
    }
    
    func scrollToUserAccountDataPage() {
        scrollView.scrollToPage(number: 1, animated: true)
        self.view.firstResponder?.resignFirstResponder()
    }
    
    func scrollToImageAndCountryPickerView() {
        scrollView.scrollToPage(number: 2, animated: true)
        self.view.firstResponder?.resignFirstResponder()
    }
    
    func cancelRegistration() {
        self.view.firstResponder?.resignFirstResponder()
        scrollView.scrollToPage(number: 0, animated: true)
    }
    
    func pickImage() {
        let image = UIImagePickerController()
        image.delegate = self
        // type of source
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true) {
            
        }
    }
    
    // this is needed to gain access to gallery
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        // set selected image from gallery to our image view
        imageAndCountryView?.viewModel.image.value = photo
        self.dismiss(animated: true)
    }
    
    
    @objc func revealLoginWindow() {
        applyBlurToBackground()
        fadeInLoginScreen(withDuration: 0.4)
    }
    
    @objc func hideLoginWindow() {
        dismissBlurFromBackground()
        fadeOutLoginScreen(withDuration: 0.4)
    }
    
    func fadeInLoginScreen(withDuration: TimeInterval) {
        containerBottomConstraint.constant -= self.containerView.frame.size.height / 2
        UIView.animate(withDuration: withDuration, animations: {
            self.containerView.alpha = 1.0
            self.swipeButton.alpha = 0.0
            self.containerView.superview?.layoutIfNeeded()
        }, completion: { result in
            self.swipeButton.isUserInteractionEnabled = false
            self.backgroundEffect.isUserInteractionEnabled = false
        })
    }
    
    func fadeOutLoginScreen(withDuration: TimeInterval) {
        self.containerBottomConstraint.constant += self.containerView.frame.size.height / 2
                UIView.animate(withDuration: withDuration, animations: {
                    self.containerView.alpha = 0.0
                    self.swipeButton.alpha = 1.0
                    self.containerView.superview?.layoutIfNeeded()
                }, completion: { result in
                    self.swipeButton.isUserInteractionEnabled = true
                    self.backgroundEffect.isUserInteractionEnabled = true
                })
    }
    
    func applyBlurToBackground() {
        UIView.animate(withDuration: 0.5) {
            self.backgroundEffect.effect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        }
    }
    
    func dismissBlurFromBackground() {
        UIView.animate(withDuration: 0.2) {
            self.backgroundEffect.effect = nil
        }
    }
    
    func goToMainScreen() {
        performSegue(withIdentifier: "mainScreenTransitionSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "mainScreenTransitionSegue") {
            let castedSegue = segue as! CircleSegue
            castedSegue.circleOrigin = view.center
        }
    }
}


extension UIScrollView {
    func scrollToPage(number: Int, animated: Bool) {
        var frame = self.frame
        frame.origin.x = frame.size.width * CGFloat(number)
        frame.origin.y = 0
        self.scrollRectToVisible(frame, animated: animated)
    }
}


extension LoginScreenViewController: CAAnimationDelegate{
    func animateLaunch(image: UIImage, bgColor: UIColor) {
//        self.view.backgroundColor = bgColor
        
        // Create and apply mask
        mask = CALayer()
        mask.contents = image.cgImage
        mask.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        mask.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        mask.position = CGPoint(x: view.frame.width / 2.0, y: view.frame.height / 2)
        view.layer.mask = mask
        
        animateDecreaseSize()
    }
    
    func animateDecreaseSize() {
        // Initial decrease the size of mask
        let decreaseSize = CABasicAnimation(keyPath: "bounds")
        decreaseSize.delegate = self
        decreaseSize.duration = 0.4
        decreaseSize.fromValue = NSValue(cgRect: mask!.bounds)
        decreaseSize.toValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: 80, height: 80))
        
        // Ensure that the animation isn't removed on completion
        decreaseSize.fillMode = .forwards
        decreaseSize.isRemovedOnCompletion = false
        
        // Add animation to mask
        mask.add(decreaseSize, forKey: "bounds")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        // Called when animateDEcreaseSize() is completed
        animateIncreaseSize()
    }
    
    func animateIncreaseSize() {
        animation = CABasicAnimation(keyPath: "bounds")
        animation.duration = 0.9
        animation.fromValue = NSValue(cgRect: mask!.bounds)
        animation.toValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: 6000, height: 6000))
        
        // Ensure that the animation isn't removed on completion
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        // Add animation to mask
        mask.add(animation, forKey: "bounds")
        
        // Fade out overlay
        UIView.animate(withDuration: 0.75, animations: {
            self.overlay.alpha = 0
        })
    }
}


extension LoginScreenViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}


func getSubviewsOfView<viewType>(v: UIView) -> [viewType] {
    var viewArray = [viewType]()

    for subview in v.subviews {
        viewArray += getSubviewsOfView(v: subview)

        if subview is viewType {
            viewArray.append(subview as! viewType)
        }
    }
    return viewArray
}


extension UIView {
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self}

        for subview: UITextField in getSubviewsOfView(v: self) {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        return nil
    }
}


