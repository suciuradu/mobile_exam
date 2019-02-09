//
//  Extensions.swift
//  MobileExam
//
//  Created by Suciu Radu on 07/02/2019.
//  Copyright © 2019 Team. All rights reserved.
//

import Foundation
import UIKit
import BRYXBanner

extension UIViewController {
    
    class var storyboardId: String {
        return "\(self)"
    }
    
    static func instantiate() -> Self {
        return viewController(viewControllerClass: self)
    }
    
    private static func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboard = UIStoryboard(name: storyboardId, bundle: Bundle.main)
        guard let scene = storyboard.instantiateInitialViewController() as? T else { fatalError() }
        
        return scene
    }
}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    public func showSuccessMessage(_ message:String) {
        let banner = Banner(title:"GOOD!", subtitle: message, image: UIImage.init(named: "check_icon"),
                            backgroundColor: #colorLiteral(red: 0.2745098174, green: 0.5949271219, blue: 0.1411764771, alpha: 1))
        banner.dismissesOnTap = true
        banner.show(duration: 3.0)
    }
    
    public func showErrorMessage(_ message:String) {
        let banner = Banner(title: "OOPS!", subtitle: message, image: UIImage(named: "warning_icon"),
                            backgroundColor: #colorLiteral(red: 0.7339776885, green: 0.1098039225, blue: 0.05098039284, alpha: 1))
        banner.dismissesOnTap = true
        banner.show(duration: 3.0)
    }
}
