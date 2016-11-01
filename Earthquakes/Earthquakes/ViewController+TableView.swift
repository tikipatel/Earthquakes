//
//  ViewController+TableView.swift
//  Earthquakes
//
//  Created by delkant on 10/26/16.
//  Copyright © 2016 Pratik Patel. All rights reserved.
//

import UIKit

extension ViewController: UITableViewDataSource { //space added for pratik

    var filteredArray: [Earthquake] {// computed property
        switch currentFilter {
        case .none: return earthquakes
        case .gt2: return earthquakes.filter{$0.magnitude > 2.0}
        case .gt4: return earthquakes.filter{$0.magnitude > 4.0}
        case .gt6: return earthquakes.filter{$0.magnitude > 6.0}
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! EarthquakeTableViewCell
        cell.earthquake = filteredArray[indexPath.row]
        return cell
    }

    

}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let earthquake = filteredArray[indexPath.row]
        performSegue(withIdentifier: "showEarthquakeDetail", sender: earthquake)
    }
    
}
