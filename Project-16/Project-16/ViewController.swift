//
//  ViewController.swift
//  Project-16
//
//  Created by Chloe Fermanis on 20/9/21.
//

import UIKit
import MapKit
import WebKit

class ViewController: UIViewController, MKMapViewDelegate, WKNavigationDelegate {

    @IBOutlet var mapView: MKMapView!
    var WikiURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Maps"
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        
        mapView.addAnnotation(london)
        mapView.addAnnotation(oslo)
        mapView.addAnnotation(paris)
        mapView.addAnnotation(rome)
        mapView.addAnnotation(washington)
        
        //mapView.addAnnotations([london, oslo, paris, rome, washington])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map View", style: .plain, target: self, action: #selector(selectMapType))

    }
    
    // Day 61 - C2: Add a UIAlertController to specify how user views the map
    @objc func selectMapType() {
            
        let ac = UIAlertController(title: "Map View", message: "Select Map Type", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: { _ in self.mapView.mapType = .standard } ))

        ac.addAction(UIAlertAction(title: "Satelite", style: .default, handler: { _ in self.mapView.mapType = .satellite } ))
        
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: { _ in self.mapView.mapType = .hybrid } ))

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem

        present(ac, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // 1
        guard annotation is Capital else { return nil }
        
        // 2 our reuse identifier
        let identifier = "Capital"
        
        // 3
        
        // Day 61 - C1: typecase the return value to MKPinAnnotationView so you can change the pin color
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            
            // 4
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            // 5
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
            
        } else {
            
            // 6
            annotationView?.annotation = annotation
        }
        // Day 61 - C1: change the pin color
        annotationView?.pinTintColor = .blue
        return annotationView
        
    }
        
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
        //let placeInfo = capital.info
        
        // Day 61 - C3: Modify the callout button so pressing it shows a web view
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WebView") as? WebViewController {
            let url = URL(string: "https://en.wikipedia.org/wiki/" + placeName!)
            vc.WikiURL = url
            navigationController?.pushViewController(vc, animated: true)
                
        }
    
        //let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        //ac.addAction(UIAlertActin(title: "OK", style: .default))
        //present(ac, animated: true)
    }
}



