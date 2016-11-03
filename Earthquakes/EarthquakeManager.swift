//
//  EarthquakeManager.swift
//  Earthquakes
//
//  Created by Macintosh on 10/29/16.
//  Copyright © 2016 Pratik Patel. All rights reserved.
//

import Foundation

class EarthquakeManager {
    
    static let sharedInstance = EarthquakeManager()
    
    private var _earthquakes = [Earthquake]()
    
    private var timeOfLastNetworkCall = Date()
    
    func earthquakes(filteredBy filter: MagFilter, completion: @escaping (Result<[Earthquake]>) -> ()) {
        if self._earthquakes.count == 0 || timeOfLastNetworkCall.timeIntervalSince(Date()) < -600 {
            self.timeOfLastNetworkCall = Date()
            getEarthquakes { result in
                switch result {
                case .error(let error):
                    completion(.error(error))
                case .success(let earthquakes):
                    if let earthquakes = earthquakes {
                        self._earthquakes = earthquakes
                        completion(.success(self.filteredEarthquakes(by: filter)))
                    } else {
                        completion(.success(nil))
                    }
                }
            }
        } else {
            completion(.success(filteredEarthquakes(by: filter)))
        }
    }
    
    private func filteredEarthquakes(by filter: MagFilter) -> [Earthquake] {
    
        switch filter {
        case .none: return self._earthquakes
        case .gt2: return self._earthquakes.filter{$0.magnitude > 2.0}
        case .gt4: return self._earthquakes.filter{$0.magnitude > 4.0}
        case .gt6: return self._earthquakes.filter{$0.magnitude > 6.0}
        }
        
    }
    private func getEarthquakes(completion: @escaping (Result<[Earthquake]>) -> ()) {
        NetworkManager.sharedInstance.get(endpoint: .all_day) { (result) in
            switch result {
            case .error(let error):
                print("error!")
                completion(.error(error))
            case .success(let data):
                guard let data = data else {
                    completion(.success(nil))
                    return
                }
                do {
                    
                    guard let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {
                        fatalError("Could not get json data!!")
                    }
                    
                    let features = jsonData["features"] as! [[String:Any]]
                    var earthquakes = [Earthquake]()
                    
                    for feature in features {
                        
                        let property = feature["properties"] as! [String:Any]
                        let earthquake = Earthquake()
                        earthquake.magnitude = property["mag"] as! Double
                        let time = property["time"] as! Int
                        earthquake.time = Date(timeIntervalSince1970: Double(time/1000))
                        earthquake.url = property["url"] as? URL
                        earthquake.place = property["place"] as! String
                        earthquake.detail = property["detail"] as? URL
                        
                        let geometry = feature["geometry"] as! [String:Any]
                        let coordinates = geometry["coordinates"] as! [Double]
                        earthquake.longitude = coordinates[0]
                        earthquake.latitude = coordinates[1]
                        earthquake.depth = coordinates[2]
                        earthquakes.append(earthquake)
                    }
                    self._earthquakes.append(contentsOf: earthquakes)
                    completion(.success(self._earthquakes))
                } catch (let error) {
                    completion(.error(error))
                }
            }
        }
    }
}
