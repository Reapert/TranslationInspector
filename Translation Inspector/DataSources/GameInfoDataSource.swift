//
//  GameInfoDataSource.swift
//  Translation Inspector
//
//  Created by Soner Yuksel on 2019-07-14.
//  Copyright © 2019 Inspector. All rights reserved.
//

import Foundation
import UIKit

enum TranslationLanguageCode: String {
    
    //English Code
    case en
    /// Spanish Code
    case es
    /// French Code
    case fr
    /// Unknown Language Code
    case none
}

typealias GridSize = (rows: Int, columns: Int)
typealias GridLocation = (row: Int, column: Int)
typealias GridBlock = (location: GridLocation?, grid: UIView?)

struct GameInfoDataSource {
    
    private var challengeList = [Challanges]()
    
    private var gameInfoViewModelList = [GameInfoViewModel]()
    
    private var gameLevelViewModelList = [GameLevelViewModel]()

    private var translations = [[String : String]]()
    
    private(set) var activeLevel = 0
    private(set) var activeTranslationsCount = [Int]()

    public var numberofChallenges: Int {
        return challengeList.count
    }
    
    public var  isFinalLevel: Bool {
        return activeLevel == numberofChallenges - 1
    }
    
    init(_ challenges: [Challanges]) {
        
        challengeList = challenges
        
        for (index, challenge) in challenges.enumerated() {
            
            gameInfoViewModelList.append(GameInfoViewModel(worldDescription: challenge.challengeWord,
                                                           languageDescription: languageDescription(sourceLanguageCode: TranslationLanguageCode(rawValue: challenge.sourceLanguage) ?? .none,
                                                                                                    targetLanguageCode: TranslationLanguageCode(rawValue: challenge.targetLanguage) ?? .none),
                                                           countDescription: String(challenge.wordLocations.count)))
            
            gameLevelViewModelList.append(GameLevelViewModel(countDescription: levelNumberDescription(for: index)))
            
            
            var levelTranslations = [String : String]()
            
            for wordLocation in challenge.wordLocations {
                levelTranslations.updateValue(wordLocation.value, forKey: wordLocation.key)
            }
            
            translations.append(levelTranslations)
            
            activeTranslationsCount.append(challenge.wordLocations.count)

            
        }
    }
    
    func specifiedLevelInformation(_ level: Int) -> (info: GameInfoViewModel?, level: GameLevelViewModel?)  {
        return (info: gameInfoViewModelList.at(level), level: gameLevelViewModelList.at(level))
    }
  
    func languageDescription(sourceLanguageCode: TranslationLanguageCode, targetLanguageCode: TranslationLanguageCode) -> String {
        
        
        let languageSource = languageCodeDescription(languageCode: sourceLanguageCode)
        let languageTarget = languageCodeDescription(languageCode: targetLanguageCode)
        
        return "\(languageSource) -> \(languageTarget)"
    }
    
    func languageCodeDescription(languageCode: TranslationLanguageCode) -> String {
        
        switch languageCode {
        case .en:
            return "English"
        case .es:
            return "Spanish"
        case .fr:
            return "French"
        default:
            return "None"
        }
    }

    func levelNumberDescription(for level: Int) -> String {
        
        return "\(level + 1) out of \(numberofChallenges)"
    }
    
    func characterGrid(for level: Int) -> [[String]]?  {
        
        return challengeList.at(level)?.characterGrid
    }
    
    func characterSequenceInGrid(for level: Int, locationList: [GridLocation]) -> String {
        
        let gridSequence = characterGrid(for: level)
        var characterSequence = ""
        
        for location in locationList {
            characterSequence += gridSequence?[location.row][location.column] ?? ""
        }
        
        return characterSequence
    }
    
    func translationsList(for level: Int) -> [[GridLocation]]? {
        
        var coordinateLocationList = [[GridLocation]]()

        guard let coordinatesList = translations.at(level) else { return nil }

        for coordinates in coordinatesList {
            let coordinateText = coordinates.key.filter { $0 != "," }
            let coordinateTextSplits = coordinateText.split(by: 2)
            
            var coordinateLocations = [GridLocation]()
            
            for coordinate in coordinateTextSplits {
                guard let coordinateLocationCharacterY = coordinate.characterAtIndex(index: 1),
                    let coordinateLocationCharacterX = coordinate.characterAtIndex(index: 0),
                    let coordinateLocationY = Int(String(coordinateLocationCharacterY)),
                    let coordinateLocationX = Int(String(coordinateLocationCharacterX)) else { return nil }
                
                coordinateLocations.append((row: coordinateLocationY, coordinateLocationX))
            }
            coordinateLocationList.append(coordinateLocations)
        }
        
        return coordinateLocationList
    }
    
    func touchGridWordExists(touchedGridList: [GridBlock], for level: Int) -> Bool {
        
        var touchedGridCoordinateLocationList = [GridLocation]()
        
        for touchedGrid in touchedGridList {
            guard let location = touchedGrid.location else { return false }
            touchedGridCoordinateLocationList.append(location)
        }
    
        guard let coordinateLocationList = translationsList(for: level) else { return false }
        
        var wordExists = false
        for coordinateLocation in coordinateLocationList {
            
            let coordinateLocationString = characterSequenceInGrid(for: level, locationList: coordinateLocation)
            
            let touchedCoordinateLocationString = characterSequenceInGrid(for: level, locationList: touchedGridCoordinateLocationList)

            let normalizedCoordinateString = touchedCoordinateLocationString.count > 1 ? touchedCoordinateLocationString[1..<touchedCoordinateLocationString.count] + touchedCoordinateLocationString[0..<1] : ""

            if coordinateLocationString == touchedCoordinateLocationString ||
                coordinateLocationString == normalizedCoordinateString {
                wordExists = true
            }
        }

        return wordExists
    }
    
    
    mutating func setActiveLevel(_ level: Int) {
        activeLevel = level
    }

    mutating func decreaseActiveTranslationsCount() -> Int {
        
        guard let numberOfActiveTranslations = activeTranslationsCount.at(activeLevel) else { return 0 }
        
        if numberOfActiveTranslations != 0 {
            activeTranslationsCount[activeLevel] = numberOfActiveTranslations - 1
        }
        
        return activeTranslationsCount[activeLevel]
    }
    


}
