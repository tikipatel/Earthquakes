//
//  NetworkManager.swift
//  Networking
//
//  Created by Pratikbhai Patel on 10/21/16.
//  Copyright © 2016 Pratik Patel. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T?)
    case error(Error)
}

class NetworkManager{
    
    private let baseURL: String = "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson"
    static let sharedInstance = NetworkManager()
    
    private init() {
        
    }
    
    func get(endpoint: Endpoint, completion: @escaping (_ result: Result<Data>) -> ()) {
        
        let session = URLSession.shared
        let endpointURL = URL(string: "\(baseURL)\(endpoint.rawValue)")!
        let task = session.dataTask(with: endpointURL) { (data, response, error) in
            guard error == nil else {
                completion(.error(NSError(domain: "com.myApp.networkErro", code: -100, userInfo: nil)))
                return
            }
            // do not perform this if gaurd fails
            completion(.success(data))
        }
        
        task.resume()
    }
    
    func post(endpoint: Endpoint, data: Data?, completion: @escaping (_ result: Result<Data>) -> ()) {
        
        let session = URLSession.shared
        let endpointURL = URL(string: "\(baseURL)\(endpoint.rawValue)")!
        var urlRequest = URLRequest(url: endpointURL)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = data
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completion(.error(NSError(domain: "com.myApp.networkError", code: -101, userInfo: nil)))
                return
            }
            // do not perform this if gaurd fails
            completion(.success(data))
        }
        task.resume()
    }

}
