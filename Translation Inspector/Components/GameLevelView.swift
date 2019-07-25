//
//  GameLevelView.swift
//  Translation Inspector
//
//  Created by Soner Yuksel on 2019-07-10.
//  Copyright © 2019 Inspector. All rights reserved.
//

import UIKit


class GameLevelView: UIView {
    
    private let stackView = UIStackView()
    
    private let countTitleLabel = UILabel()
    private let countDescriptionLabel = UILabel()

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
        
        
        countTitleLabel.do {
            $0.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
            $0.textColor = .black
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        countDescriptionLabel.do {
            $0.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
            $0.textColor = .black
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
    }

    private func doLayout() {
        
        addSubview(stackView)
        
        stackView.constrain([
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        stackView.addArrangedSubviews([countTitleLabel, countDescriptionLabel])
        stackView.setCustomSpacing(10.0, after: countTitleLabel)
        
    }
    
    func setViewModel(_ viewModel: GameLevelViewModel) {
        countTitleLabel.text = viewModel.countTitle
        countDescriptionLabel.text = viewModel.countDescription
        
    }
}
