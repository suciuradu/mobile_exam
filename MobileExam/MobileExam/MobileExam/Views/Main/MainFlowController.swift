//
//  MainFlowController.swift
//  MobileExam
//
//  Created by Suciu Radu on 07/02/2019.
//  Copyright © 2019 Team. All rights reserved.
//

import Foundation
import UIKit

class MainFlowController: Coordinator {
    
    var mainViewController: UIViewController?
    var childCoordinators: [Constants.CoordinatorKeys : Coordinator] = [:]
    
    init(with navigationController: UINavigationController) {
        self.mainViewController = navigationController
        self.childCoordinators = [:]
        
        start()
    }
    
    func start() {
        let viewController = MainViewController.instantiate()
        let viewModel = MainViewModel()
        viewController.viewModel = viewModel
        setRoot(to: viewController)
    }
}


