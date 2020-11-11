//
//  ViewController.swift
//  Project22
//
//  Created by diayan siat on 12/10/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet var distanceReading: UILabel!
    var locationManager: CLLocationManager?
    
    var ibeaconFirstDetected = true
    var currentBeaconUUID: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            //can this detect if monitoring is available?
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                //can we detect how far away a beacon is
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        addBeaconRegion(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5", major: 123, minor: 456, identifier: "MyBeacon")
        addBeaconRegion(uuidString: "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6", major: 123, minor: 456, identifier: "Radius Networks")
        addBeaconRegion(uuidString: "92AB49BE-4127-42F4-B532-90fAF1E26491", major: 123, minor: 456, identifier: "TwoCanoes")
    }
    
    
    func addBeaconRegion(uuidString: String, major: CLBeaconMajorValue, minor: CLBeaconMinorValue, identifier: String) {
          let uuid = UUID(uuidString: uuidString)!
          let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: major, minor: minor, identifier: identifier)
          
          locationManager?.startMonitoring(for: beaconRegion)
          locationManager?.startRangingBeacons(in: beaconRegion)
      }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            
            switch distance {
                
            case .unknown:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UKNOWN"
                
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
                
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
                
            @unknown default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UKNOWN"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        }else {
            update(distance: .unknown)
        }
    }
}

