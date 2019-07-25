//
//  IntroDataSource.swift
//  Translation Inspector
//
//  Created by Soner Yuksel on 2019-07-09.
//  Copyright © 2019 Inspector. All rights reserved.
//

import Foundation

struct IntroDataSource {
    
    private var introDetails: [IntroViewModel]
    
    init() {
        
        introDetails = [IntroViewModel(title: "Purpose of the Game",
                                       detail: "Find all translations in the grid.\n\nSelect the letters by dragging on the cells in the grid."),
                        IntroViewModel(title: "Rules of the Game",
                                       detail: "Every word has one or more translations to be found in the grid.\n\nIf all the translations are found, player can proceed next level."),
                        IntroViewModel(title: "How to Win",
                                       detail: "Find all the translations in every level and complete the game")]
        
    }

    func isEmpty() -> Bool {
        
        return introDetails.isEmpty
    }
    
    func numberOfDetails() -> Int {
        
        return introDetails.count
    }
    
    func retrieveDetails(of page: Int) -> IntroViewModel? {
        
        return introDetails.at(page)
    }

}
