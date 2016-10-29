//
//  MapPin.swift
//  Earthquakes
//
//  Created by Tyler on 10/28/16.
//  Copyright © 2016 Pratik Patel. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapPin : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
