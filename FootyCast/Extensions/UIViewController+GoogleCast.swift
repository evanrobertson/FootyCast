//
//  UIViewController+GoogleCast.swift
//
//  Created by Evan Robertson on 19/3/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import UIKit
import GoogleCast

extension UIViewController {
    func addCastButton() {
        let castButton = GCKUICastButton.init(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        let castButtonItem = UIBarButtonItem(customView: castButton)
        navigationItem.setRightBarButton(castButtonItem, animated: false)
    }
}
