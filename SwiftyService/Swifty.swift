//
//  Swifty.swift
//  SwiftyService
//
//  Created by Amit Singh on 09/08/19.
//  Copyright © 2019 Amit Singh. All rights reserved.
//

import Foundation
public typealias handler = (Data?, Failure?) -> Void

protocol Swifty {
    var session: URLSession {get}
}

extension Swifty {
    
    func createSessionTask(forURLRequest request: URLRequest, completionHandler completion: @escaping handler) -> URLSessionDataTask {
        let task  = session.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .serviceFailure)
                return
            }
            if httpResponse.statusCode == 200 {
                if let data = data {
                        completion(data, nil)
                    } else {
                        completion(nil, .anyOtherFailure)
                    }
                } else {
                    completion(nil, .serviceFailure)
                }
        }
        return task
    }
}
