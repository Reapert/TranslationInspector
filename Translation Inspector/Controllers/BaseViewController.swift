//
//  BaseViewController.swift
//  Translation Inspector
//
//  Created by Soner Yuksel on 2019-07-08.
//  Copyright © 2019 Inspector. All rights reserved.
//

import UIKit

/// Base View Controller which implements default characteristics for all the
/// UIViewControllers that will be used inside the application 
class BaseViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    var prefersBackButtonText: Bool {
        return false
    }
    
    var prefersBackButtonHidden: Bool {
        return false
    }
    
    var prefersNavigationBarHidden: Bool {
        return false
    }

}
