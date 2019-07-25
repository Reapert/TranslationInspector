//
//  LaunchViewController.swift
//  Translation Inspector
//
//  Created by Soner Yuksel on 2019-07-08.
//  Copyright © 2019 Inspector. All rights reserved.
//

import UIKit

class LaunchViewController: BaseViewController {

    private let imageView = UIImageView()
    private let spinner = UIActivityIndicatorView(style: .whiteLarge)
    private let detailLabel = UILabel()
    
    private var isLoading = false {
        didSet {
            spinner.isHidden = !isLoading
            isLoading ? spinner.startAnimating() : spinner.stopAnimating()
        }
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()

        setTheme()
        doLayout()
      
        retrieveChallanges()
    }
    
    // MARK: Theme Interface Components
    private func setTheme() {
        
        imageView.do {
            $0.image = #imageLiteral(resourceName: "LaunchIcon")
            $0.contentMode = .scaleAspectFit
        }
        
        spinner.color = .black
        
        detailLabel.do {
            $0.font = UIFont.systemFont(ofSize: 25.0, weight: .bold)
            $0.textColor = .black
            $0.textAlignment = .center
            $0.numberOfLines = 1
            $0.minimumScaleFactor = 0.5
            $0.text = "Translation Inspector"
        }
        
    }
    
    // MARK: Layout Interface Elements
    private func doLayout() {
        
        /// Add Subviews
        view.addSubviews([imageView, spinner, detailLabel])
        
        /// Constrain ImageView
        imageView.constrain([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        
        /// Constrain Detail Label
        detailLabel.constrain([
            detailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -44.0)
        ])
        
        /// Constrain Spinner
        spinner.constrain([
            spinner.bottomAnchor.constraint(equalTo: detailLabel.topAnchor, constant: -44.0),
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    /// Retrieve Challanges from server
    func retrieveChallanges() {
        
        isLoading = true
    
        Client.shared.retrieveChallengeList { [weak self] result in
            guard let self = self else { return }

            self.isLoading = false
            
            switch result {
                case .success(let challengeList):
                
                let introViewController = IntroViewController()
                introViewController.setChallengeList(challengeList)
                
                introViewController.modalTransitionStyle = .crossDissolve
                self.present(introViewController, animated: true, completion: nil)
                
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
                    self?.retrieveChallanges()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
