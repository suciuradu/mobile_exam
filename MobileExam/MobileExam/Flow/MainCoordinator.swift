//
//  MainCoordinator.swift
//  MobileExam
//
//  Created by Suciu Radu on 07/02/2019.
//  Copyright © 2019 Team. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    var mainViewController: UIViewController? {
        return tabBarController
    }
    
    var childCoordinators: [Constants.CoordinatorKeys : Coordinator]
    var mainCoordinator: MainFlowController?
    
    private var tabBarController: UITabBarController?
    
    init() {
        self.childCoordinators = [:]
        start()
    }
    
    func start() {
        tabBarController = UITabBarController()
        self.tabBarController?.tabBar.tintColor = #colorLiteral(red: 0.1176470588, green: 0.7176470588, blue: 0.6901960784, alpha: 1)
        self.tabBarController?.tabBar.unselectedItemTintColor = UIColor.black
        //self.tabBarController?.tabBar.barTintColor =
        
        
        
        mainCoordinator = MainFlowController(with: UINavigationController())
        mainCoordinator?.mainViewController?.tabBarItem = UITabBarItem(title: "Acasa", image: UIImage(), selectedImage: UIImage())
        addChild(coordinator: mainCoordinator!, with: .main)

        guard
            let main = mainCoordinator?.mainViewController
            else { fatalError("Coordinators need to have a mainViewController") }
        
        tabBarController?.viewControllers = [main]
    }
}
