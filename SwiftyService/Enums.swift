//
//  Enums.swift
//  SwiftyService
//
//  Created by Amit Singh on 09/08/19.
//  Copyright © 2019 Amit Singh. All rights reserved.
//

import Foundation

public typealias HttpHeader = [String: String]
public typealias Parameters<T:Codable> = T

public enum Result<T:Codable,Failure> {
    case success(T)
    case failure(Failure)
}

public enum Failure: Error {
    case parsingFailure
    case serviceFailure
    case timeOutFailure
    case inValidURL
    case anyOtherFailure
    var localizedDescription: String {
        switch self {
        case .parsingFailure: return "Please recheck your model and json from api"
        case .serviceFailure: return "Response Unsuccessful"
        case .timeOutFailure,.anyOtherFailure:
                return "Some thing went wrong. Please try again"
        case .inValidURL: return "Please review your api url"
        }
    }
}

public enum HttpMethod: String {
    case get    = "GET"
    case post   = "POST"
    case delete = "DELETE"
    case put    = "PUT"
}
