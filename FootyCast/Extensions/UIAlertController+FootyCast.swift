//
//  UIAlertController+FootyCast.swift
//  FootyCast
//
//  Created by Evan Robertson on 17/3/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import UIKit

// MARK: - Alerts
extension UIAlertController {
    
    static func showYesNoAlert(_ title: String?, message: String?, controller: UIViewController, noCompletion: @escaping () -> Void, yesCompletion: @escaping () -> Void) {
        
        let noAction = UIAlertAction(title: "No", style: .cancel) { _ in noCompletion() }
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in yesCompletion() }
        
        showAlert(title, message: message, controller: controller, actions: [noAction, yesAction])
    }
}

extension UIAlertController {
    
    static func showTwoButtonAlert(_ title: String?, message: String?, primaryButtonTitle: String?, secondaryButtonTitle: String?, controller: UIViewController, secondaryCompletion: @escaping () -> Void, primaryCompletion: @escaping () -> Void) {
        
        let noAction = UIAlertAction(title: secondaryButtonTitle ?? "No", style: .cancel) { _ in secondaryCompletion() }
        let yesAction = UIAlertAction(title: primaryButtonTitle ?? "Yes", style: .default) { _ in primaryCompletion() }
        
        showAlert(title, message: message, controller: controller, actions: [noAction, yesAction])
    }
}

extension UIAlertController {
    
    static func showOkAlert(_ title: String?, message: String?, controller: UIViewController, okCompletion: @escaping () -> Void) {
        
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { _ in okCompletion() }
        showAlert(title, message: message, controller: controller, actions: [okAction])
    }
}

extension UIAlertController {
    
    static func showDestructiveAlert(
        _ title: String?,
        message: String?,
        controller: UIViewController,
        cancelTitle: String = "Cancel",
        destructiveTitle: String = "Delete",
        cancelHandler: ((UIAlertAction) -> Void)?,
        destructiveHandler: ((UIAlertAction) -> Void)?) {
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler)
        let destructiveAction = UIAlertAction(title: destructiveTitle, style: .destructive, handler: destructiveHandler)
        showAlert(title, message: message, controller: controller, actions: [cancelAction, destructiveAction])
    }
}

extension UIAlertController {
    
    static func showAlert(_ title: String?, message: String?, controller: UIViewController, actions: [UIAlertAction]) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addActions(actions)
        controller.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Action Sheet
extension UIAlertController {
    /**
     Helper function for creating action sheets to be presented
     
     - Parameter actions: Actions to be presented in the action sheet
     - Returns: UIAlertController instance configured as an action sheet
     */
    static func actionSheet(actions: UIAlertAction...) -> UIAlertController {
        return actionSheet(actions: actions)
    }
    
    /**
     Helper function for creating action sheets, use varadic version when in need of an alert controller
     setup as an actionsheet
     
     - Parameter actions: Array of actions to be presented in the action sheet
     - Returns: UIAlertController instance configured as an action sheet
     */
    private static func actionSheet(actions: [UIAlertAction]) -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addActions(actions)
        return alertController
    }
    
    /**
     Helper function for creating then presenting an action sheet
     This is an iPhone only method, given the action sheet needs to be displayed as
     a popover on iPad. Use the `actionSheet(actions: UIAlertAction...) -> UIAlertController` method
     for iPads
     
     - Parameter controller: The viewcontroller that will handle presentation of the action sheet
     - Parameter actions: Actions to be presented in the action sheet
     - Returns: UIAlertController instance configured as an action sheet
     */
    static func showActionSheet(_ controller: UIViewController, actions: UIAlertAction...) {
        guard UIDevice.current.userInterfaceIdiom == .phone else { return }
        
        let alertController = actionSheet(actions: actions)
        controller.present(alertController, animated: true) {}
    }
}

extension UIAlertController {
    
    func addActions(_ actions: UIAlertAction...) {
        addActions(actions)
    }
    
    private func addActions(_ actions: [UIAlertAction]) {
        
        for action in actions {
            addAction(action)
        }
    }
}
