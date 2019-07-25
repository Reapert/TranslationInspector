//
//  GameInfoView.swift
//  Translation Inspector
//
//  Created by Soner Yuksel on 2019-07-10.
//  Copyright © 2019 Inspector. All rights reserved.
//

import UIKit


enum StackViewType {
    case horizontal
    case vertical
}

class GameInfoView: UIView {

    private let wordTitleLabel = UILabel()
    private let wordDescriptionLabel = UILabel()
    
    private let languageTitleLabel = UILabel()
    private let languageDescriptionLabel = UILabel()

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
        
        wordTitleLabel.do {
            $0.font = UIFont.systemFont(ofSize: 25.0, weight: .bold)
            $0.textColor = .black
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        wordDescriptionLabel.do {
            $0.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
            $0.textColor = .black
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        languageTitleLabel.do {
            $0.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
            $0.textColor = .black
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        languageDescriptionLabel.do {
            $0.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
            $0.textColor = .black
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
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
        
        let contentStackView = createStackView()
        let challengeWordStackView = createStackView()
        let numberTranslationTitleStackView = createStackView()
        let translateLanguageStackView = createStackView()
        let translateStackView = createStackView(.horizontal)
        
        addSubview(contentStackView)
        
        contentStackView.constrain([
            contentStackView.leftAnchor.constraint(equalTo: leftAnchor),
            contentStackView.rightAnchor.constraint(equalTo: rightAnchor),
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        contentStackView.addArrangedSubviews([challengeWordStackView, translateStackView])
        contentStackView.setCustomSpacing(15.0, after: challengeWordStackView)

        challengeWordStackView.addArrangedSubviews([wordTitleLabel, wordDescriptionLabel])
        challengeWordStackView.setCustomSpacing(10.0, after: wordTitleLabel)
        
        translateLanguageStackView.addArrangedSubviews([languageTitleLabel, languageDescriptionLabel])
        translateLanguageStackView.setCustomSpacing(10.0, after: languageTitleLabel)
        
        numberTranslationTitleStackView.addArrangedSubviews([countTitleLabel, countDescriptionLabel])
        numberTranslationTitleStackView.setCustomSpacing(10.0, after: countTitleLabel)

        translateStackView.addArrangedSubviews([translateLanguageStackView, numberTranslationTitleStackView])
        translateStackView.setCustomSpacing(10.0, after: translateLanguageStackView)

    }
    
    func createStackView(_ type: StackViewType = .vertical) -> UIStackView {
        
        let stackView = UIStackView()
        
        switch type {
        case .vertical:
            stackView.do {
                $0.alignment = .center
                $0.distribution = .fill
                $0.axis = .vertical
            }
        case .horizontal:
            stackView.do {
                $0.alignment = .center
                $0.distribution = .fillEqually
                $0.axis = .horizontal
            }
        }
        return stackView
    }
    
    func setViewModel(_ viewModel: GameInfoViewModel) {
        wordTitleLabel.text = viewModel.wordTitle
        wordDescriptionLabel.text = viewModel.worldDescription
        
        languageTitleLabel.text = viewModel.languageTitle
        languageDescriptionLabel.text = viewModel.languageDescription
        
        countTitleLabel.text = viewModel.countTitle
        countDescriptionLabel.text = viewModel.countDescription
    }
    
    func setTranslationCount(_ numberOfTranslations: Int) {
        countDescriptionLabel.text = String(numberOfTranslations)

    }
}
