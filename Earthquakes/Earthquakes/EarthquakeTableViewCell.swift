//
//  EarthquakeTableViewCell.swift
//  Earthquakes
//
//  Created by Patrick Garner on 10/26/16.
//  Copyright © 2016 Pratik Patel. All rights reserved.
//

import UIKit

class EarthquakeTableViewCell: UITableViewCell {

    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var magnitudeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var earthquake: Earthquake? {
        didSet {
            guard let earthquake = earthquake else { return }
            placeLabel.text = earthquake.place
            magnitudeLabel.text = String(earthquake.magnitude)
            dateLabel.text = EarthquakeDateFormatter.sharedInstance.regularDateString(from: earthquake.time)
            timeLabel.text = EarthquakeDateFormatter.sharedInstance.regularTimeString(from: earthquake.time)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
    

}
