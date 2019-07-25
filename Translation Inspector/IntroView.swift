//
//  IntroView.swift
//  Translation Inspector
//
//  Created by Soner Yuksel on 2019-07-09.
//  Copyright © 2019 Inspector. All rights reserved.
//

import UIKit

class IntroView: UIView {
    
    private let titleLabel = UILabel()
    private let detailLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        
        setTheme()
        doLayout()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTheme() {
        
        titleLabel.do {
            $0.font = UIFont.systemFont(ofSize: 25.0, weight: .bold)
            $0.textColor = .black
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        detailLabel.do {
            $0.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
            $0.textColor = .black
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
    }
    
    private func doLayout() {
        
        addSubviews([titleLabel, detailLabel])
        
        titleLabel.constrain([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 80.0),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20.0),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20.0)
        ])
    
        detailLabel.constrain([
            detailLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            detailLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            detailLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20.0),
            detailLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20.0)
        ])
    }
    
    func setViewModel(_ viewModel: IntroViewModel) {
        titleLabel.text = viewModel.title
        detailLabel.text = viewModel.detail
    }
}
