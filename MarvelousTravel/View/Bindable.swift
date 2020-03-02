//
//  Protocols.swift
//  SignInScreen
//
//  Created by Dmytro Salenko on 2/15/20.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    public func observe<T>(for observable: Observable<T>, with: @escaping (T) -> ()) {
        observable.bind { observable, value  in
            DispatchQueue.main.async {
                with(value)
            }
        }
    }
}

protocol Bindable: NSObjectProtocol{
    var binder: Observable<BindingType> { get set }
    associatedtype BindingType: Equatable
    
    func observingValue() -> BindingType?
    func updateValue(with value: BindingType)
    func bind(with observable: Observable<BindingType>)
    func getBinderValue() -> BindingType?
    func setBinderValue(with value: BindingType?)
    func register(for observable: Observable<BindingType>)
    func valueChanged()
}


fileprivate struct AssociatedKeys {
    static var binder: UInt8 = 0
}


extension Bindable where Self: UIControl {

    var binder: Observable<BindingType> {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.binder) as? Observable<BindingType> else {
                let newValue = Observable<BindingType>()
                objc_setAssociatedObject(self, &AssociatedKeys.binder, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return newValue
            }
            return value
        }
        set(newValue) {
             objc_setAssociatedObject(self, &AssociatedKeys.binder, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func getBinderValue() -> BindingType? {
        return binder.value
    }

    func setBinderValue(with value: BindingType?) {
        binder.value = value
    }

    func register(for observable: Observable<BindingType>) {
        binder = observable
    }

    func valueChanged() {
        if binder.value != self.observingValue() {
            setBinderValue(with: self.observingValue())
        }
    }
}


extension UITextField: Bindable {
    public typealias BindingType = String
    
    public func observingValue() -> String? {
        return self.text
    }
    
    public func updateValue(with value: String) {
        self.text = value
    }
    
    @objc func valueChanged() {
        if binder.value != self.observingValue() {
            setBinderValue(with: self.observingValue())
        }
    }
    
    func bind(with observable: Observable<String>) {
        self.addTarget(self, action: #selector(self.valueChanged), for: [.editingChanged, .valueChanged])
        self.register(for: observable)
        self.observe(for: observable) { [weak self] (value) in
            self?.updateValue(with: value)
        }
    }
}
