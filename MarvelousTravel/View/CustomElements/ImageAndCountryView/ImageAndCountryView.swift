//
//  UserProfileDataView.swift
//  SignInScreen
//
//  Created by Dmytro Salenko on 2/26/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit
import BFWControls

class ImageAndCountryView: NibView {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var cityTextField: AutocompletionSearchTextField!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    let viewModel = AdditionalRegistrationStepViewModel()
    
    let isImagePickRequested: Observable<Bool> = Observable(false)
    
    // flags
    var isResetRequested: Observable<Bool> = Observable(false)
    var isTransitionRequested: Observable<Bool> = Observable(false)
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        iconImageView.isUserInteractionEnabled = true
        iconImageView.addGestureRecognizer(tapGestureRecognizer)
        
        skipButton.addTarget(self, action: #selector(skipButtonPressed), for: .touchUpInside)
        finishButton.addTarget(self, action: #selector(finishRegistration), for: .touchUpInside)
        
        self.observe(for: viewModel.image) {
            value in
            self.iconImageView.image = value
        }
        
        self.observe(for: cityTextField.viewModel.selectedCity) {
            value in
            self.viewModel.selectedCity.value = value
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        isImagePickRequested.value = true
    }
    
    @objc func skipButtonPressed(sender: UIButton) {
        isTransitionRequested.value = true
    }
    
    @objc func finishRegistration(sender: UIButton) {
        viewModel.finishRegistration()
    }
}
