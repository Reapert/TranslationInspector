//
//  Client+Challanges.swift
//  Translation Inspector
//
//  Created by Soner Yuksel on 2019-07-09.
//  Copyright © 2019 Inspector. All rights reserved.
//

import Foundation


extension Client {
    
    /// Get the challange list from the server
    ///
    /// - note: If the call succeeds, `Challanges` will be set to the serialized object
    /// - returns: A `URLSessionTask` if the request starts
    @discardableResult
    public func retrieveChallengeList(_ completion: @escaping RequestCompletion<[Challanges]>) -> URLSessionTask? {
        
        let endpoint = Endpoint<Challanges>(.get, "PuzzleTextFile.txt")
        
        return task(endpoint: endpoint, { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let wrapper):
                completion(.success(wrapper))
            }
        })
    }
}
