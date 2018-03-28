//
//  SettingsCoordinator.swift
//  FootyCast
//
//  Created by Evan Robertson on 25/2/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import UIKit
import Valet
import SwiftyUserDefaults

class SettingsCoordinator : RootViewCoordinator {
    var childCoordinators: [Coordinator] = []
    
    var rootViewController: UIViewController {
        return navigationController
    }
    
    private lazy var navigationController: UINavigationController = {
        return UINavigationController(rootViewController: settingsViewController)
    }()
    
    private lazy var settingsViewController: SettingsViewController = {
       return StoryboardScene.Settings.settingsViewController.instantiate()
    }()
    
    let valet = Valet.sharedAccessGroupValet(with: Identifier(nonEmpty: Bundle.main.bundleIdentifier!)!, accessibility: .whenUnlocked)
    
    init() {
        
    }
    
    func start() {
        settingsViewController.delegate = self

        settingsViewController.setInitialValues(username: valet[.username],
                                                password: valet[.password],
                                                appToken: valet[.appToken])
    }
}

extension SettingsCoordinator: SettingsViewControllerDelegate {
    func settingsViewController(_ settingsViewController: SettingsViewController,
                                updateUsername username: String?,
                                password: String?,
                                appToken: String?) {
        
        // Clear the cache if the username is different to the one we have stored in the keychain
        let currentUsername = valet[.username]
        if (currentUsername != username) {
            Defaults.remove(.aflToken)
        }
        
        valet[.username] = username
        valet[.password] = password
        valet[.appToken] = appToken
    }
}
