//
//  GameViewController.swift
//  Translation Inspector
//
//  Created by Soner Yuksel on 2019-07-10.
//  Copyright © 2019 Inspector. All rights reserved.
//

import UIKit

class GameViewController: BaseViewController {

    private let contentStackView = UIStackView()
    
    private let gameInfoView = GameInfoView()
    private let gameBoardView = GameBoardView()
    private let gameLevelView = GameLevelView()
    
    private var gameInfoDataSource: GameInfoDataSource
    
    init(gameInfoDataSource: GameInfoDataSource) {
        self.gameInfoDataSource = gameInfoDataSource
        
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNewLevel(0)

        setTheme()
        doLayout()
    }
    
    private func setTheme() {
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Magnify")).then {
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
        }
        navigationItem.titleView = imageView

        gameBoardView.delegate = self
        
        contentStackView.do {
            $0.alignment = .center
            $0.distribution = .fill
            $0.axis = .vertical
            $0.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
            $0.isLayoutMarginsRelativeArrangement = true
        }
        
    }

    private func doLayout() {
        
        view.addSubview(contentStackView)
        
        contentStackView.constrain([
            contentStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentStackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            contentStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 25.0),
        ])
        
        contentStackView.addArrangedSubviews([gameInfoView, gameBoardView, gameLevelView])
        contentStackView.setCustomSpacing(15.0, after: gameInfoView)
        contentStackView.setCustomSpacing(20.0, after: gameBoardView)

        gameBoardView.constrain([
            gameBoardView.leftAnchor.constraint(equalTo: contentStackView.layoutMarginsGuide.leftAnchor, constant: 18.0),
            gameBoardView.rightAnchor.constraint(equalTo: contentStackView.layoutMarginsGuide.rightAnchor, constant: -18.0),
            gameBoardView.heightAnchor.constraint(equalTo: gameBoardView.widthAnchor)
        ])
        
    }
    
    private func setGameInfoData(_ gameInfoDataSource: GameInfoDataSource, level: Int) {
        
        self.gameInfoDataSource = gameInfoDataSource
        
        guard let generalInfo = gameInfoDataSource.specifiedLevelInformation(level).info,
              let levelInfo = gameInfoDataSource.specifiedLevelInformation(level).level,
              let characterGrid = gameInfoDataSource.characterGrid(for: level) else { return }

        gameBoardView.createGameBoard(gameBoardViewModel: GameBoardViewModel(characterGrid: characterGrid))

        
        gameInfoView.setViewModel(GameInfoViewModel(worldDescription: generalInfo.worldDescription,
                                                    languageDescription: generalInfo.languageDescription,
                                                    countDescription: generalInfo.countDescription))
        
        gameLevelView.setViewModel(GameLevelViewModel(countDescription: levelInfo.countDescription))

    
    }
    
    private func setupNewLevel(_ level: Int) {
        
        gameInfoDataSource.setActiveLevel(level)
        setGameInfoData(gameInfoDataSource, level: gameInfoDataSource.activeLevel)
    }
    
}


// MARK: Game Board View Controller
extension GameViewController: GameBoardViewDelegate {
    
    func processTouchedGrid(touchedGridList: [GridBlock]) {
        
        let touchedGridExists = gameInfoDataSource.touchGridWordExists(touchedGridList: touchedGridList, for: gameInfoDataSource.activeLevel)
        
        gameBoardView.processTouchedGrid(touchedGridExists)
        
        if touchedGridExists {
      
            let decreasedActiveTranslationsCount =  gameInfoDataSource.decreaseActiveTranslationsCount()
            
            gameInfoView.setTranslationCount(decreasedActiveTranslationsCount)
            
            if decreasedActiveTranslationsCount == 0 {
                
                if gameInfoDataSource.isFinalLevel {
                    let alert = UIAlertController(title: "Congratulations !!!", message: "Press Done to restart the game :)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] _ in
                        guard let self = self else { return }
                        self.setupNewLevel(0)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    let alert = UIAlertController(title: "Wow! Congratulations, you did it !!!", message: "Level Complete.\nPress OK to continue to the next level.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                        guard let self = self else { return }
                        self.setupNewLevel(self.gameInfoDataSource.activeLevel + 1)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else {
                let alert = UIAlertController(title: "More Translations Needed !!!", message: "Find other translations to finish the level.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
