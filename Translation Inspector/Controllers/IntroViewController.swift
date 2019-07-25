//
//  IntroViewController.swift
//  Translation Inspector
//
//  Created by Soner Yuksel on 2019-07-09.
//  Copyright © 2019 Inspector. All rights reserved.
//

import Foundation
import UIKit

class IntroViewController: BaseViewController {

    /// User Interface Elements
    private var introViews = [IntroView]()
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let pageControl = UIPageControl()
    private let startButton = UIButton()
    
    /// Data Source
    private let dataSource = IntroDataSource()
    private(set) var challengeList = [Challanges]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTheme()
        doLayout()
    }
    
    // MARK: Theme Interface Components
    private func setTheme() {
        
        setIntroViews()

        scrollView.do {
            $0.showsHorizontalScrollIndicator = false
            $0.isPagingEnabled = true
            $0.delegate = self
        }
        
        stackView.do {
            $0.axis = .horizontal
            $0.distribution = .fill
        }
        
        pageControl.do {
            $0.currentPage = 1
            $0.numberOfPages = 3
            $0.currentPageIndicatorTintColor = .black
            $0.pageIndicatorTintColor = .gray
        }
        
        startButton.do {
            $0.setTitle("Start", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 2.0
            $0.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        }
    }
    
    // MARK: Layout Interface Elements
    private func doLayout() {
        
        view.addSubviews([scrollView, pageControl, startButton])
        
        scrollView.constrain([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        pageControl.constrain([
            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            pageControl.leftAnchor.constraint(equalTo: view.leftAnchor),
            pageControl.rightAnchor.constraint(equalTo: view.rightAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 8.0)
        ])
        
        startButton.constrain([
            startButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 35.0),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 60.0),
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -55.0),
            startButton.heightAnchor.constraint(equalToConstant: 45.0)
        ])
        
        scrollView.addSubview(stackView)
        stackView.constrain([
            stackView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
        
        for intro in introViews {
            intro.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
            stackView.addArrangedSubview(intro)
        }
    }
    
    /// Setting up the introduction views which is fetched from intro dataSource
    private func setIntroViews() {
        
        var currentScreen = 0, totalScreen = dataSource.numberOfDetails()
        repeat {
            
            let introView = IntroView()
            if let viewModel = dataSource.retrieveDetails(of: currentScreen) {
                introView.setViewModel(viewModel)
                introViews.append(introView)
            }
            currentScreen += 1
        } while (currentScreen <= totalScreen)
    }
    
    func setChallengeList(_ challenges: [Challanges]) {
        challengeList = challenges
    }
    
    /// Start the game using the challenges fetched from server
    @objc
    private func startGame() {
        
        let gameViewController = GameViewController(gameInfoDataSource: GameInfoDataSource(challengeList))
        
        let navigationController = UINavigationController(rootViewController: gameViewController)
        navigationController.modalTransitionStyle = .crossDissolve
        
        self.present(navigationController, animated: true, completion: nil)
    }
}

extension IntroViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }

}
