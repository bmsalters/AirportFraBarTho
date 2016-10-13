//
//  DetailViewController.swift
//  SQLiteCRUD
//
//  Created by Frank Molengraaf on 13/10/2016.
//

import UIKit
import MapKit
import CoreLocation
class DetailViewController: UIViewController {
    
    public var airport : Airport?
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let schipholAirport = CLLocation(latitude: 52.3094593, longitude: 4.7600949)
        let currentAirport = CLLocation(latitude: (airport?.latitude)!, longitude: (airport?.longitude)!)
        let regionRadius : CLLocationDistance = 1000
        
        
        nameLabel.text = airport?.name
        distanceLabel.text = String(schipholAirport.distance(from: currentAirport) / 1000) + "km";
        
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,                                                            regionRadius * 10000.0, regionRadius * 10000.0)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        
        centerMapOnLocation(location: currentAirport)
        
        let schipholAirportLocation = CLLocationCoordinate2DMake((airport?.latitude)!, (airport?.longitude)!)
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = schipholAirportLocation
        dropPin.title = airport?.name
        mapView.addAnnotation(dropPin)
        
//        let currentAirportLocation = CLLocationCoordinate2DMake(52.3094593, 4.7600949)swag
//        let dropPin2 = MKPointAnnotation()
//        dropPin2.coordinate = currentAirportLocation
//        dropPin2.title = "Amsterdam Schiphol"
//        mapView.addAnnotation(dropPin2)
    }
}
