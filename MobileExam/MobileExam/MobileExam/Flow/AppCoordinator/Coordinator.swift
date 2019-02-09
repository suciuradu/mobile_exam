//
//  Coordinator.swift
//  MobileExam
//
//  Created by Suciu Radu on 07/02/2019.
//  Copyright © 2019 Team. All rights reserved.
//

import Foundation
import UIKit

enum Constants {
    enum CoordinatorKeys: String {
        case main
        case settings
    }
}

protocol Coordinator: class {
    var mainViewController: UIViewController? { get }
    var childCoordinators: [Constants.CoordinatorKeys:Coordinator] { get set }
    
    func start()
    func addChild(coordinator: Coordinator, with key: Constants.CoordinatorKeys)
    func removeChild(coordinator: Coordinator)
}

extension Coordinator {
    
    func addChild(coordinator: Coordinator, with key: Constants.CoordinatorKeys) {
        childCoordinators[key] = coordinator
    }
    
    func removeChild(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0.value !== coordinator }
    }
    
}

extension Coordinator {
    func setRoot(to viewController: UIViewController) {
        if let navigationController = mainViewController as? UINavigationController {
            //            navigationController.navigationBar.tintColor = UIColor.black
            //            navigationController.navigationBar.barTintColor = UIColor.white
            navigationController.viewControllers = [viewController]
        }
    }
    
    func navigate(to viewController: UIViewController, with presentationStyle: navigationStyle, animated: Bool = true) {
        switch presentationStyle {
        case .present:
            mainViewController?.present(viewController, animated: animated, completion: nil)
        case .push:
            (mainViewController as? UINavigationController)?.pushViewController(viewController, animated: true)
        }
    }
    
}

enum navigationStyle {
    case present
    case push
}
