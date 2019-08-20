//
//  SwiftyApiManager.swift
//  SwiftyService
//
//  Created by Amit Singh on 09/08/19.
//  Copyright © 2019 Amit Singh. All rights reserved.
//

import Foundation
import UIKit

public class SwiftyApiManager: Swifty {
    
    let session: URLSession
    
    public init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }
    
}

extension SwiftyApiManager {
   
    public func download(formUrl urlString: String, withMethod httpMehthod: HttpMethod? = nil, completion: @escaping (DownloadResult<Data?, Failure?>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMehthod?.rawValue ?? HttpMethod.get.rawValue
        let task =  createSessionTask(forURLRequest: request) { (data, failures) in
            if let response = data {
                completion(.success(response))
            }
            else{
                completion(.failure(failures))
            }
        }
        task.resume()
       
    }
    
    public func connectApi<T>(withEndPoint endPoint: String?, withRequestType method:HttpMethod? = nil, withParameters parameters: [String: Any]? = nil, withHeader headers: HttpHeader? = nil, decode: T.Type, completion: @escaping (Result<T?, Failure?>) -> Void) where T : Codable {
        
        guard let urlString = endPoint else {
            completion(.failure(.inValidURL))
            return
        }
        if let endPointURL =  URL(string: urlString){
            var request = URLRequest(url: endPointURL)
            request.allHTTPHeaderFields = headers
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = method?.rawValue ?? HttpMethod.get.rawValue
            if let json = parameters {
                if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) {
                    request.httpBody = jsonData
                }
            }
            
            self.createRequest(with: request, decode: T.self) { (response) in
                switch response {
                    case .success(let model):
                            completion(.success(model))
                case .failure(let failure):
                        completion(.failure(failure))
                }
            }
        } else {
           completion(.failure(.inValidURL))
        }
    }

    
    
    private func createRequest<T>(with request: URLRequest, decode:T.Type, completion: @escaping (Result<T, Failure?>) -> Void) where T : Codable {
       
        let task =  createSessionTask(forURLRequest: request) { (data, failures) in
            if let response = data {
                if let responseModel = try? JSONDecoder().decode(T.self, from: response){
                    completion(.success(responseModel))
                }
                else{
                    completion(.failure(.parsingFailure))
                }
            }
            else{
                completion(.failure(.serviceFailure))
            }
        }
            task.resume()
    }
}

