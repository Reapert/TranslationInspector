//
//  Requests.swift
//  Translation Inspector
//
//  Created by Soner Yuksel on 2019-07-08.
//  Copyright © 2019 Inspector. All rights reserved.
//

import Foundation
import UIKit

public enum Result<T> {
    case success(T)
    case failure(Swift.Error)
}

public typealias RequestCompletion<T> = (Result<T>) -> Void

extension Client {

    /// This task method is designed to serialize a list of objects from a text file
    /// Text file contains another json object every different line
    ///
    /// After constructing the URLSession Data Task response data from text file converted into string
    /// Every line is decoded as the generic object type defined by the function
    /// Finally decoded response is appended into array of generic type
    ///
    /// - Parameters:
    ///   - endpoint: Endpoint that request hits
    ///   - completion: Result object with serialized object list or error
    /// - Returns: URL Session Data Task
    
    func task<T>(endpoint: Endpoint<T>, _ completion: @escaping RequestCompletion<[T]>) -> URLSessionTask? {
        
        guard let request = urlRequest(endpoint: endpoint) else { return nil }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                
                //TODO: NEED TO IMPLEMENT LOGGING
                
                if let objectListText = String(data: data, encoding: .utf8) {
                    
                    let objectList = objectListText.components(separatedBy: "\n")
                    var responseWrapperList = [T]()
                    
                    for object in objectList {
                        if let data = object.data(using: .utf8) {
                            do {
                                let responseWrapper = try JSONDecoder().decode(T.self, from: data)
                                responseWrapperList.append(responseWrapper)
 
                            } catch let error {
                                DispatchQueue.main.async{
                                    completion(.failure(error))
                                }
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        completion(.success(responseWrapperList))
                    }
                }
            }
        }
        
        task.resume()
        
        return task
    }
    
    private func urlRequest<T>(endpoint: Endpoint<T>) -> URLRequest? {
        
        let urlRequest = buildURLRequest(endpoint: endpoint, headers: buildHeaders(extraHeaders: endpoint.headers))
        return urlRequest
    }
    
    private func buildHeaders(extraHeaders: HTTPHeaders) -> HTTPHeaders {

        var headers: HTTPHeaders = [:]
        headers["Content-Type"] = "text/plain"

        extraHeaders.forEach({
            headers[$0.key] = $0.value
            
            if $0.value.isEmpty {
                headers.removeValue(forKey: $0.key)
            }
        })
        
        return headers
    }
    
    func buildURLRequest<T>(endpoint: Endpoint<T>, headers: HTTPHeaders) -> URLRequest? {
        
        let urlString = "\(endpoint.baseURL ?? configuration?.baseURL ?? "")\(endpoint.route)"
        
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        
        request.httpMethod = endpoint.method.rawValue
        
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        return request
    }
    
}
