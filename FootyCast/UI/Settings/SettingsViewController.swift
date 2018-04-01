//
//  SettingsViewController.swift
//  FootyCast
//
//  Created by Evan Robertson on 25/2/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import UIKit
import Valet

class SettingsViewController : UITableViewController {
    
    @IBOutlet weak var usernameTextField: SettingsTextField!
    @IBOutlet weak var passwordTextField: SettingsTextField!
    @IBOutlet weak var appTokenTextField: SettingsTextField!
    @IBOutlet weak var versionLabel: UILabel!
    
    var saveButtonItem: UIBarButtonItem!
    
    weak var delegate: SettingsViewControllerDelegate?
    
    private var currentUsername: String?
    private var currentPassword: String?
    private var currentAppToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(update(sender:)))
        navigationItem.setRightBarButton(saveButtonItem, animated: false)
        saveButtonItem.isEnabled = false
        
        usernameTextField.addTarget(self, action: #selector(usernameTextFieldDidChange(sender:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange(sender:)), for: .editingChanged)
        appTokenTextField.addTarget(self, action: #selector(appTokenTextFieldDidChange(sender:)), for: .editingChanged)
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        appTokenTextField.delegate = self
        
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"],
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] {
            versionLabel.text = "FootyCast \(version) (\(build))"
        } else {
            versionLabel.text = "FootyCast"
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        usernameTextField.text = currentUsername
        passwordTextField.text = currentPassword
        appTokenTextField.text = currentAppToken
    }
    
    func setInitialValues(username: String?, password: String?, appToken: String?) {
        currentUsername = username ?? ""
        currentPassword = password ?? ""
        currentAppToken = appToken ?? ""
    }
    
    internal func hasChanges() -> Bool {
        return (usernameTextField.text != currentUsername) ||
            (passwordTextField.text != currentPassword) ||
            (appTokenTextField.text != currentAppToken)
    }
    
    @objc func update(sender: Any) {
        view.endEditing(true)
        
        let username = usernameTextField.text
        let password = passwordTextField.text
        let appToken = appTokenTextField.text
        
        delegate?.settingsViewController(self,
                                         updateUsername: username,
                                         password: password,
                                         appToken: appToken)
        
        currentUsername = username
        currentPassword = password
        currentAppToken = appToken
        saveButtonItem.isEnabled = hasChanges()
    }
    
    @objc func usernameTextFieldDidChange(sender: Any) {
        saveButtonItem.isEnabled = hasChanges()
    }
    
    @objc func passwordTextFieldDidChange(sender: Any) {
        saveButtonItem.isEnabled = hasChanges()
    }
    
    @objc func appTokenTextFieldDidChange(sender: Any) {
        saveButtonItem.isEnabled = hasChanges()
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        
        return true
    }
}

protocol SettingsViewControllerDelegate: class {
    func settingsViewController(_ settingsViewController: SettingsViewController,
                                updateUsername username: String?,
                                password: String?,
                                appToken: String?)
}

class SettingsTextField : UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }
}
