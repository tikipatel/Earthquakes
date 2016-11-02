//
//  EarthquakeDateFormatter.swift
//  Earthquakes
//
//  Created by Pratikbhai Patel on 11/1/16.
//  Copyright © 2016 Pratik Patel. All rights reserved.
//

import Foundation

class EarthquakeDateFormatter {
    
    static let sharedInstance = EarthquakeDateFormatter()
    
    private let regularDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
//        dateFormatter.dateStyle = .long
//        dateFormatter.dateFormat = "MM/dd/YYYY"
        return dateFormatter
    }()
    
    private let regularTimeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
//        dateFormatter.dateFormat = "hh:mm A"
        return dateFormatter
    }()
    
    private let fancyDateTimeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM. d, yyyy '@' hh:mm a"
        return dateFormatter
    }()
    
    private init() {
        
    }
    
    func regularDateString(from date: Date) -> String {
        return regularDateFormatter.string(from: date)
    }
    
    func regularTimeString(from date: Date) -> String {
        return regularTimeFormatter.string(from: date)
    }
    
    func fancyDateTimeString(from date: Date) -> String {
        return fancyDateTimeFormatter.string(from: date)
    }
}
