//
//  Configuration.swift
//  Translation Inspector
//
//  Created by Soner Yuksel on 2019-07-08.
//  Copyright © 2019 Inspector. All rights reserved.
//

import Foundation

/// The available log levels
public enum LogLevel: Int {
    /// No logs
    case none
    /// Simple logging
    case simple
    /// Verbose logging
    case verbose
}



/// A set of information for configuring a `Client` instance.
public struct Configuration {

    /// The base URL to use for all network requests
    public var baseURL: String
    
    /// The log level for this client
    public var logLevel: LogLevel = .none
    
    public init(baseURL: String,  logLevel: LogLevel = .none) {
        self.baseURL = baseURL
        self.logLevel = logLevel
    }
    
}
