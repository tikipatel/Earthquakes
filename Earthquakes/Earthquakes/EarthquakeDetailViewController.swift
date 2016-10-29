//
//  EarthquakeDetailViewController.swift
//  Earthquakes
//
//  Created by Tyler on 10/28/16.
//  Copyright © 2016 Pratik Patel. All rights reserved.
//

import UIKit
import MapKit
import AudioToolbox

class EarthquakeDetailViewController: UIViewController {
    
    /// Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var locationText: UILabel!
    @IBOutlet weak var dateTimeTitle: UILabel!
    @IBOutlet weak var dateTimeText: UILabel!
    @IBOutlet weak var magnitudeTitle: UILabel!
    @IBOutlet weak var magnitudeText: UILabel!
    @IBOutlet weak var depthTitle: UILabel!
    @IBOutlet weak var depthText: UILabel!
    
    /// Variables
    var howManyVibrations = 6
    let gdaLat = 29.655141
    let gdaLon = -82.422835
    let placeTitle = "Gainesville Dev Academy"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = placeTitle
        
        mapView.setCenter(CLLocationCoordinate2D(latitude: gdaLat, longitude: gdaLon), animated: true)
        mapView.camera.altitude = 800
        
        let mapPin = MapPin(coordinate: CLLocationCoordinate2D(latitude: gdaLat, longitude: gdaLon), title: placeTitle, subtitle: nil)
        mapView.addAnnotation(mapPin)
        mapView.selectAnnotation(mapPin, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rumble()
        mapView.shake(count: Float(3 * howManyVibrations), for: 0.3 * Double(howManyVibrations), withTranslation: -15)
    }
    
    func rumble() {
        AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate), { [weak self] in
            self?.howManyVibrations -= 1
            if (self?.howManyVibrations)! > 0 {
                self?.rumble()
            }
        })
    }
    
    
    

}




public extension UIView {
    
    func shake(count : Float? = nil,for duration : TimeInterval? = nil,withTranslation translation : Float? = nil) {
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        animation.repeatCount = count ?? 2
        animation.duration = (duration ?? 0.5)/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.byValue = translation ?? -5
        layer.add(animation, forKey: "shake")
    }    
}
