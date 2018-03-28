//
//  AppCoordinator.swift
//  FootyCast
//
//  Created by Evan Robertson on 24/2/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import UIKit
import GoogleCast
import Moya
import Hydra

class AppCoordinator : RootViewCoordinator {
    var childCoordinators: [Coordinator] = []
    
    var rootViewController: UIViewController {
        return navigationController
    }
    
    private let stubbing: Stubbing
    
    private lazy var navigationController: UINavigationController = {
        let firstVC = UIViewController()
        firstVC.view.backgroundColor = .white
        return UINavigationController(rootViewController: firstVC)
    }()
    
    // MARK: - Init
    
    init(window: UIWindow, stubbing: Stubbing) {
        self.stubbing = stubbing
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
    func start() {
        
        let tabBarCoordinator = TabBarCoordinator(stubbing: stubbing)
        addChildCoordinator(childCoordinator: tabBarCoordinator)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 1)) {
            self.rootViewController.present(tabBarCoordinator.rootViewController, animated: true, completion: {
                tabBarCoordinator.start()
            })
        }
    }
}
