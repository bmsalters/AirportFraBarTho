//
//  DetailViewController.swift
//  SQLiteCRUD
//
//  Created by Bart Salters on 13/10/2016.
//  Copyright © 2016 Diederich Kroeske. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class DetailViewController: UIViewController {
    
    let schipholAirport = CLLocation(latitude: 51.5719, longitude:4.7683);
    let currentAirport = CLLocation(latitude: -43.5320, longitude:172.6362);

    public var airport : Airport?
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let schipholAirport = CLLocation(latitude: 52.3094593, longitude: 4.7600949)
        let currentAirport = CLLocation(latitude: (airport?.latitude)!, longitude: (airport?.longitude)!)
        let regionRadius : CLLocationDistance = 1000
        nameLabel.text = airport?.name
//        CLLocationDistance distanceInMeters = [schipholAirport distanceFromLocation: currentAirport]
        
        var distanceInM = schipholAirport.distance(from: currentAirport);
        
        centerMapOnLocation(location: schipholAirport)
    }
}
