//
//  ViewController.swift
//  Project16
//
//  Created by diayan siat on 23/09/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//


//NB:: Using the assistant editor, please create an outlet for your map view called mapView. You should also set your view controller to be the delegate of the map view by Ctrl-dragging from the map view to the orange and white view controller button just above the layout area

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let london = Capitals(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 summer olympic", wikiUrl: "https://en.wikipedia.org/wiki/London")
        let oslo = Capitals(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.", wikiUrl: "https://en.wikipedia.org/wiki/Oslo")
        let paris = Capitals(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.", wikiUrl: "https://en.wikipedia.org/wiki/Paris")
        let rome = Capitals(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.", wikiUrl: "https://en.wikipedia.org/wiki/Rome")
        let washington = Capitals(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.", wikiUrl: "https://en.wikipedia.org/wiki/Washington,_D.C.")
        
        //        mapView.addAnnotation(london)
        //        mapView.addAnnotation(oslo)
        //        mapView.addAnnotation(paris)
        //        mapView.addAnnotation(rome)
        //        mapView.addAnnotation(washington)
        
        //same as adding the annotations individually above
        mapView.addAnnotations([london, oslo, paris, rome, washington])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map Type", style: .plain, target: self, action: #selector(selectMapType))
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //If the annotation isn't from a capital city, it must return nil so iOS uses a default view.
        guard annotation is Capitals else {return nil}
        
        //Define a reuse identifier. This is a string that will be used to ensure we reuse annotation views as much as possible.
        let identifier = "Capital"
        
        //Try to dequeue an annotation view from the map view's pool of unused views.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        //If it isn't able to find a reusable view, create a new one using MKPinAnnotationView and sets its canShowCallout property to true. This triggers the popup with the city name
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            //Create a new UIButton using the built-in .detailDisclosure type. This is a small blue "i" symbol with a circle around it.
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
                        
        }else{
            //If it can reuse a view, update that view to use a different annotation.
            annotationView?.annotation = annotation
        }
        
        //Challenge: change pins color
        annotationView?.pinTintColor = UIColor.blue
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capitals else { return }
        
//        let placeName = capital.title
//        let placeInfo = capital.info
//

        self.openInWebView(url: capital.wikiUrl)
//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
    }
    
    @objc func selectMapType(action: UIAlertAction) {
        
        let ac = UIAlertController(title: "Map Type", message: "Select different map view" , preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: selectedMap))
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: selectedMap))
        ac.addAction(UIAlertAction(title: "Terrain", style: .default, handler: selectedMap))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        
    }
    
    func selectedMap(action: UIAlertAction) {
        let mapType = action.title
        
        if mapType == "Satellite" {
            mapView.mapType = MKMapType.satellite
        }else if mapType == "Hybrid" {
            mapView.mapType = MKMapType.hybrid
        }else {
            mapView.mapType = MKMapType.mutedStandard
        }

    }
    
    func openInWebView(url: String) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WebView") as? WebViewController {
            vc.website = url
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

