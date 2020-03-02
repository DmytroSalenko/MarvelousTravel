//
//  ViewController.swift
//  SignInScreen
//
//  Created by Dmytro Salenko on 2/9/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit

class LoginScreenViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    
    var loginView: LoginView?
    var userDataView: UserAccountDataView?
    var imageAndCountryView: ImageAndCountryView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        loginView = logInScreenSetupAndLoad()
        userDataView = userAccountDataScreenSetupAndLoad()
        imageAndCountryView = userProfileDataViewSetupAndLoad()
        
        setScrollViewConstraints()
    }
    
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
                self.switchToImageAndCountryPickerView()
            }
        }
        
        scrollView.addSubview(userDataView)
        return userDataView
    }
    
    func userProfileDataViewSetupAndLoad() -> ImageAndCountryView {
        let imageAndCountryView = ImageAndCountryView(frame: scrollView.bounds)
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
    }
    
    func switchToImageAndCountryPickerView() {
        scrollView.scrollToPage(number: 2, animated: true)
    }
    
    func cancelRegistration() {
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
}

extension UIScrollView {
    func scrollToPage(number: Int, animated: Bool) {
        var frame = self.frame
        frame.origin.x = frame.size.width * CGFloat(number)
        frame.origin.y = 0
        self.scrollRectToVisible(frame, animated: animated)
    }
}

extension UITextField {
    func markAsValidated(isValid: Bool) {
        if !isValid {
            self.layer.borderColor = UIColor.red.cgColor
            self.layer.borderWidth = 1.0
        } else {
            self.layer.borderWidth = 0.0
            self.layer.borderColor = nil
        }
    }
    
    func setValidator(validator: Observable<Bool>) {
        self.observe(for: validator) {
            value in
            self.markAsValidated(isValid: value)
        }
    }
}
