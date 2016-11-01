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
    @IBOutlet weak var locationText: UILabel!
    @IBOutlet weak var dateTimeText: UILabel!
    @IBOutlet weak var magnitudeText: UILabel!
    @IBOutlet weak var depthText: UILabel!
    
    /// Variables
    var earthquake: Earthquake? {
        didSet {
            guard let earthquake = earthquake else { return }
            howManyVibrations = Int(earthquake.magnitude)
        }
    }
    var howManyVibrations = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let earthquake = earthquake else {
            
            let alert = UIAlertController(title: "No Earthquake Set", message: "Something went wrong in setting the earthquake for the detail page... please go back.", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay :(", style: .default, handler: { (action) in
                DispatchQueue.main.async {
                    _ = self.navigationController?.popViewController(animated: true)
                }
            })
            
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        title = earthquake.place
        setupMap(for: earthquake)
        setupLabels(for: earthquake)
    }
    
    func setupMap(for earthquake: Earthquake) {
        mapView.setCenter(CLLocationCoordinate2D(latitude: earthquake.latitude, longitude: earthquake.longitude), animated: true)
        mapView.camera.altitude = 1000
        
        let mapPin = MapPin(coordinate: CLLocationCoordinate2D(latitude: earthquake.latitude, longitude: earthquake.longitude), title: earthquake.place, subtitle: nil)
        mapView.addAnnotation(mapPin)
        mapView.selectAnnotation(mapPin, animated: true)
    }
    
    func setupLabels(for earthquake: Earthquake) {
        
        locationText.text = earthquake.place
        magnitudeText.text = String(earthquake.magnitude)
        depthText.text = String(earthquake.depth) + " km"
        dateTimeText.text = EarthquakeDateFormatter.sharedInstance.fancyDateTimeString(from: earthquake.time)
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
