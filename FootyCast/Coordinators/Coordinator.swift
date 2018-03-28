//
//  Coordinator.swift
//  FootyCast
//
//  Created by Evan Robertson on 24/2/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import UIKit

protocol Coordinator : class {
    var childCoordinators: [Coordinator] { get set }
}

extension Coordinator {
    /// Add a child coordinator to the parent
    func addChildCoordinator(childCoordinator: Coordinator) {
        self.childCoordinators.append(childCoordinator)
    }
    
    /// Remove a child coordinator from the parent
    func removeChildCoordinator(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
    }
}

public protocol RootViewControllerProvider: class {
    // The coordinators 'rootViewController'. It helps to think of this as the view
    // controller that can be used to dismiss the coordinator from the view hierarchy.
    var rootViewController: UIViewController { get }
}

/// A Coordinator type that provides a root UIViewController
typealias RootViewCoordinator = Coordinator & RootViewControllerProvider
