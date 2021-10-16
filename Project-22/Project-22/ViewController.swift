//
//  ViewController.swift
//  Project-22
//
//  Created by Chloe Fermanis on 14/10/21.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var circleView: UIView!
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var beaconName: UILabel!
    
    var locationManager: CLLocationManager?
    
    var alertShown = false
    var beaconIdentifier = ""

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        distanceReading.textColor = .white
        circleView.layer.cornerRadius = circleView.frame.width / 2
        circleView.clipsToBounds = true
        
        view.backgroundColor = .white
        
        // Do any additional setup after loading the view.
    }


    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    print("start scanning")
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        
        //let uuid = UUID(uuidString: "92AB49BE-4127-42F4-B532-90fAF1E26491")!
        //let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!

//        let constraint = CLBeaconIdentityConstraint(uuid: uuid, major: 123, minor: 456)
//        let region = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: "TwoCanoes 92AB49BE")
//        locationManager?.startMonitoring(for: region)
//        locationManager?.startRangingBeacons(satisfying: constraint)
        
        addBeacon(uuid: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5", major: 123, minor: 456, identifier: "MyBeacon")
        //addBeacon(uuid: "92AB49BE-4127-42F4-B532-90fAF1E26491", major: 123, minor: 456, identifier: "TwoCanoes 92AB49BE")
        //addBeacon(uuid: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0", major: 123, minor: 456, identifier: "Apple AirLocate E2C56DB5")

    }
        
    
    
    func addBeacon(uuid: String, major: CLBeaconMajorValue, minor: CLBeaconMinorValue, identifier: String) {
            
        let uuid = UUID(uuidString: uuid)!
        let constraint = CLBeaconIdentityConstraint(uuid: uuid, major: major, minor: minor)
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: identifier)
        beaconIdentifier = beaconRegion.identifier
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: constraint)
        
        }
    
    func update(distance: CLProximity) {
        
        // Challenge 3: add a circle and animate to scale it up and down depending on distance
        UIView.animate(withDuration: 1) {
            
            switch distance {
            
            case .far:
                self.circleView.backgroundColor = UIColor.blue
                self.distanceReading.text = "FAR"
                self.circleView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)

            case .near:
                self.circleView.backgroundColor = UIColor.orange
                self.distanceReading.text = "NEAR"
                self.circleView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

            case .immediate:
                self.circleView.backgroundColor = UIColor.red
                self.distanceReading.text = "RIGHT HERE"
                self.circleView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

                
            default:
                self.circleView.backgroundColor = UIColor.gray
                self.distanceReading.text = "UKNNOWN"
                self.circleView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        
        if let beacon = beacons.first {
            // Challenge 2: display beacon identifier on label
            beaconName.text = beaconIdentifier
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
        
        // Challenge 1: show alert when beacon is first detected.
        
        if !alertShown {
            alertShown = true
            let ac = UIAlertController(title: "Detection Alert", message: "Beacon is first detected.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            
        }
        
    }
}

