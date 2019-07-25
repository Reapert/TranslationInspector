//
//  Challenge.swift
//  Translation Inspector
//
//  Created by Soner Yuksel on 2019-07-09.
//  Copyright © 2019 Inspector. All rights reserved.
//

import Foundation

/// General challange that will be updated from the server
public struct Challanges: Codable {
    
    /// Source Language for the challenge
    public let sourceLanguage: String
    
    /// Word to be checked for translationdefine the grid
    public let challengeWord: String
    
    /// List of Array of Strings used in order to define grid
    /// Every line is defined by element of the character grid (left to right)
    public let characterGrid: [[String]]
    
    /// Word location in the grid
    /// Each key is a list of coordinates in the format: x1, y1, x2, y2
    /// And value is the target word in that location
    public let wordLocations: [String : String]
    
    /// Target Language of specific challenge
    public let targetLanguage: String
    
    
    enum CodingKeys: String, CodingKey {
        case sourceLanguage = "source_language"
        case challengeWord = "word"
        case characterGrid = "character_grid"
        case wordLocations = "word_locations"
        case targetLanguage = "target_language"
    }
    
}
