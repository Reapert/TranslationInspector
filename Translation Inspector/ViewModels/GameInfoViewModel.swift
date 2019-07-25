//
//  GameInfoViewModel.swift
//  Translation Inspector
//
//  Created by Soner Yuksel on 2019-07-10.
//  Copyright © 2019 Inspector. All rights reserved.
//

import Foundation

struct GameInfoViewModel {
    
    let wordTitle: String
    let worldDescription: String
    
    let languageTitle: String
    let languageDescription: String
    
    let countTitle: String
    let countDescription: String
    
    init(wordTitle: String = "Word", worldDescription: String,
         languageTitle: String = "Translation", languageDescription: String,
         countTitle: String = "# translations", countDescription: String) {
        
        self.wordTitle = wordTitle
        self.worldDescription = worldDescription
        self.languageTitle = languageTitle
        self.languageDescription = languageDescription
        self.countTitle = countTitle
        self.countDescription = countDescription
    }
}

struct GameLevelViewModel {
    
    let countTitle: String
    let countDescription: String
    
    init(countTitle: String = "# Levels:", countDescription: String) {
        self.countTitle = countTitle
        self.countDescription = countDescription
    }
}

struct GameBoardViewModel {
    
    let characterGrid: [[String]]
    
    init(characterGrid: [[String]] ) {
        self.characterGrid = characterGrid
    }
}
