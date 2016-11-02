//
//  ViewController+TableView.swift
//  Earthquakes
//
//  Created by delkant on 10/26/16.
//  Copyright © 2016 Pratik Patel. All rights reserved.
//

import UIKit

extension ViewController: UITableViewDataSource { //space added for pratik
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return earthquakes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! EarthquakeTableViewCell
        cell.earthquake = earthquakes[indexPath.row]
        return cell
    }

    

}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let earthquake = earthquakes[indexPath.row]
        performSegue(withIdentifier: "showEarthquakeDetail", sender: earthquake)
    }
    
}
