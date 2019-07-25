//
//  Utils.swift
//  Translation Inspector
//
//  Created by Soner Yuksel on 2019-07-08.
//  Copyright © 2019 Inspector. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit


extension UIView {
    
    /// Constrain function used for activating a group of Layout Constraints
    ///
    /// - Parameter constraints: List of Constraints
    @discardableResult
    func constrain(_ constraints: [NSLayoutConstraint]) -> Self {
        NSLayoutConstraint.activate(constraints)
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    /// Function helping to add subviews in one line
    ///
    /// - Parameter listofViews: List of Views
    @discardableResult
    func addSubviews(_ listofViews: [UIView]) -> Self {
        for view in listofViews {
            self.addSubview(view)
        }
        return self
    }
    
    /// Pin view to another view
    ///
    /// - Parameters:
    ///   - view: super view to be pinned
    ///   - insets: inset value
    @discardableResult
    func pinTo(_ view: UIView, insets: UIEdgeInsets = .zero) -> Self {

        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.left),
            self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -insets.right),
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom)
        ])

        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
}

extension UIStackView {
    
    /// Function helping to add arranged subviews in one line
    ///
    /// - Parameter listofViews: List of Views
    @discardableResult
    func addArrangedSubviews(_ listofViews: [UIView]) -> Self {
        for view in listofViews {
            self.addArrangedSubview(view)
        }
        return self
    }
}


extension Array {
    
    /// Obtain an item in this array safely if the index is valid
    ///
    /// - parameter index: An index within the array
    /// - returns: An element at the given index, or nil if the index is out of range
    public func at(_ index: Index) -> Element? {
        if index >= 0 && index < count {
            return self[index]
        }
        return nil
    }
}

extension String {
    
    func characterAtIndex(index: Int) -> Character? {
        var currentIndex = 0
        for char in self {
            if currentIndex == index {
                return char
            }
            currentIndex += 1
        }
        return nil
    }
    
    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()
        
        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }
        
        return results.map { String($0) }
    }
    
    subscript(_ range: CountableRange<Int>) -> String {
        
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
    
}

// The MIT License (MIT)
//
// Copyright (c) 2015 Suyeol Jeon (xoul.kr)

public protocol Do {}

extension Do where Self: Any {

    /// Executing into closures and enclosing them into a block
    ///
    /// titleLabel.do {
    ///     $0.font = UIFont.systemFont(ofSize: 25.0, weight: .bold)
    ///     $0.textColor = .black
    ///     $0.textAlignment = .center
    ///     $0.numberOfLines = 0
    /// }
    public func `do`(_ block: (Self) -> Void) {
        block(self)
    }
    
    /// Makes it available to set properties with closures just after initializing.
    ///
    /// let label = UILabel().then {
    ///     $0.font = UIFont.systemFont(ofSize: 25.0, weight: .bold)
    ///     $0.textColor = .black
    ///     $0.textAlignment = .center
    ///     $0.numberOfLines = 0
    /// }
    public func then(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }

}
extension NSObject: Do {}

