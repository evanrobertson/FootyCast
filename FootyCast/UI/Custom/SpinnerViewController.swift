//
//  SpinnerViewController.swift
//  FootyCast
//
//  Created by Evan Robertson on 20/3/18.
//  Copyright © 2018 Evan Robertson. All rights reserved.
//

import UIKit
import SnapKit

class SpinnerViewController : UIViewController {
    private var color: UIColor = UIColor.black
    private var text: String?
    
    private var container: UIView?
    private var effectView: UIVisualEffectView?
    private var spinner: InstagramActivityIndicator?
    private var textLabel: UILabel?
    private var constraints: [NSLayoutConstraint] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }
    
    init(title: String?, color: UIColor) {
        super.init(nibName: nil, bundle: nil)
        
        self.color = color
        self.text = title
        
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        let container = UIView(frame: CGRect.zero)
        container.layer.cornerRadius = 5
        container.clipsToBounds = true
        self.container = container
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        let effectView = UIVisualEffectView(effect: blurEffect)
        self.effectView = effectView
        
        let spinner = InstagramActivityIndicator()
        spinner.strokeColor = self.color
        spinner.configureTTASpinner()
        self.spinner = spinner
        
        let stackView = UIStackView(arrangedSubviews: [spinner])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        
        if let text = self.text {
            let textLabel = UILabel()
            textLabel.text = text
            stackView.addArrangedSubview(textLabel)
        }
        
        container.addSubview(effectView)
        container.addSubview(stackView)
        view.addSubview(container)
        
        container.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.lessThanOrEqualTo(270)
        }
        
        effectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(8, 16, 8, 16))
            
            if let textLabel = self.textLabel {
                make.width.equalTo(textLabel)
            }
        }
        
        spinner.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let spinner = self.spinner {
            spinner.startAnimating()
        }
    }
}

extension SpinnerViewController {
    
    static func showSpinnerView(_ title: String?, color: UIColor, controller: UIViewController, completion: (()->Void)? = nil) {
        
        let spinnerViewController = SpinnerViewController(title: title, color: color)
        controller.present(spinnerViewController, animated: true, completion: completion)
    }
}

extension InstagramActivityIndicator {
    func configureTTASpinner() {
        self.numSegments = 16
        self.lineWidth = 4
    }
}

