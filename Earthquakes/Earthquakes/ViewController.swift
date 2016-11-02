//
//  ViewController.swift
//  Earthquakes
//
//  Created by Pratikbhai Patel on 10/25/16.
//  Copyright © 2016 Pratik Patel. All rights reserved.
//

import UIKit

enum MagFilter {
    case none
    case gt2
    case gt4
    case gt6
}

class ViewController: UIViewController {

    var earthquakes = [Earthquake]()
    
    var currentFilter: MagFilter = .none
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Earthquakes"
        updateEarthquakes()
    }

    func updateEarthquakes() {
        EarthquakeManager.sharedInstance.earthquakes(filteredBy: currentFilter) { result in
            
            switch result {
            case .error(let error):
                let alert = UIAlertController(title: "Could not get earthquakes!", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Okay :(", style: .default, handler: { (action) in
                })
                alert.addAction(okayAction)
                self.present(alert, animated: true, completion: nil)
            case .success(let earthquakes):
                guard let earthquakes = earthquakes else {
                    return
                }
                self.earthquakes = earthquakes
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }

        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func filterButtonPressed(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Filter Earthquakes", message: "Select filter criteria", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Reset Filter", style: .cancel) { (action) in
            print("Reset filter pressed.")
            self.currentFilter = .none
            self.updateEarthquakes()
            
        }
        
        let greaterThan2Action = UIAlertAction(title: ">2", style: .default) { (action) in
            print(">2 pressed.")
            self.currentFilter = .gt2
            self.updateEarthquakes()
        }
        
        let greaterThan4Action = UIAlertAction(title: ">4", style: .default) { (action) in
            print(">4 pressed.")
            self.currentFilter = .gt4
            self.updateEarthquakes()
        }
        
        let greaterThan6Action = UIAlertAction(title: ">6", style: .default) { (action) in
            print(">6 pressed.")
            self.currentFilter = .gt6
            self.updateEarthquakes()
        }
        
        
        alertController.addAction(cancelAction)
        alertController.addAction(greaterThan2Action)
        alertController.addAction(greaterThan4Action)
        alertController.addAction(greaterThan6Action)
        
        present(alertController, animated: true) { 
        
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let earthquake = sender as? Earthquake  {
            if segue.identifier == "showEarthquakeDetail" {
                guard let detailVC = segue.destination as? EarthquakeDetailViewController else { return }
                detailVC.earthquake = earthquake
            }
        }
    }
}

