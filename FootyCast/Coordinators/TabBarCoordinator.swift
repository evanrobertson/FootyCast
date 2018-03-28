//
//  TabBarCoordinator.swift
//  FootyCast
//
//  Created by Evan Robertson on 24/2/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import UIKit

class TabBarCoordinator : RootViewCoordinator {
    var childCoordinators: [Coordinator] = []
    
    var rootViewController: UIViewController {
        return tabBarController
    }
    
    private let stubbing: Stubbing
    
    private lazy var tabBarController: UITabBarController = {
       return StoryboardScene.Home.homeViewController.instantiate()
    }()
    
    init(stubbing: Stubbing) {
        self.stubbing = stubbing
    }
    
    func start() {
        let settingsCoordinator = SettingsCoordinator()
        addChildCoordinator(childCoordinator: settingsCoordinator)
        settingsCoordinator.start()
        
        let replaysCoordinator = ReplaysCoordinator(stubbing: stubbing)
        addChildCoordinator(childCoordinator: replaysCoordinator)
        replaysCoordinator.start()
        
        let liveCoordinator = LiveCoordinator(stubbing: stubbing)
        addChildCoordinator(childCoordinator: liveCoordinator)
        liveCoordinator.start()
        
        tabBarController.setViewControllers([
            replaysCoordinator.rootViewController,
            liveCoordinator.rootViewController,
            settingsCoordinator.rootViewController],
                                            animated: false)
    }
}
