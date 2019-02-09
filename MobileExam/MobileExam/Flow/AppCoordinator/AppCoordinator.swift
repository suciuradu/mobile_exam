//
//  AppCoordinator.swift
//  MobileExam
//
//  Created by Suciu Radu on 07/02/2019.
//  Copyright © 2019 Team. All rights reserved.
//

import UIKit


class AppCoordinator {
    
    static var shared = AppCoordinator(in: UIWindow())
    
    private var window: UIWindow
    
    private var rootViewController: UIViewController? {
        didSet {
            window.rootViewController = rootViewController
        }
    }
    
    var mainCoordinator: MainCoordinator?
    
    
    init(in window: UIWindow) {
        self.window = window
        self.window.backgroundColor = .white
        self.window.makeKeyAndVisible()
    }
    
    public func start() {
        showMain()
    }
    
    public func showMain() {
        mainCoordinator = MainCoordinator()
        showCoordinator(mainCoordinator)
    }
    
    private func showCoordinator(_ coordinator: Coordinator?) {
        guard let coordinator = coordinator else { fatalError("Coordinator should be initialized") }
        rootViewController = coordinator.mainViewController
    }
}

