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
    
    var earthquakes: [Earthquake] {
        return _earthquakes
    }
    
    func getEarthquakes(completion: @escaping ([Earthquake]?) -> ()) {
        NetworkManager.sharedInstance.get(endpoint: .all_day) { (result) in
            switch result {
            case .error( _):
                print("error!")
                completion(nil)
            case .success(let data):
                guard let data = data else {
                    completion(nil)
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
                    completion(self.earthquakes)
                    dump(self._earthquakes)
                } catch (let error) {
                    dump(error)
                    completion(nil)
                }
            }
        }
    }
}
