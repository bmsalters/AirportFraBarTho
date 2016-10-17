//
//  DetailViewController.swift
//  SQLiteCRUD
//
//  Created by Frank Molengraaf on 13/10/2016.
//

import UIKit
import MapKit
import CoreLocation
class DetailViewController: UIViewController, MKMapViewDelegate {
    
        public var airport : Airport?
        @IBOutlet weak var mapView: MKMapView!
        @IBOutlet weak var nameLabel: UILabel!
        @IBOutlet weak var distanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let schipholAirport = CLLocation(latitude: 52.3094593, longitude: 4.7600949)
        let currentAirport = CLLocation(latitude: (airport?.latitude)!, longitude: (airport?.longitude)!)
        nameLabel.text = airport?.name
        distanceLabel.text = String(schipholAirport.distance(from: currentAirport) / 1000) + "km";

        
        // Add mappoints to Map
        let schipholAirportLocation = CLLocationCoordinate2DMake((airport?.latitude)!, (airport?.longitude)!)
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = schipholAirportLocation
        dropPin.title = airport?.name
        mapView.addAnnotation(dropPin)
        
        let currentAirportLocation = CLLocationCoordinate2DMake(52.3094593, 4.7600949)
        let dropPin2 = MKPointAnnotation()
        dropPin2.coordinate = currentAirportLocation
        dropPin2.title = "Amsterdam Schiphol"
        mapView.addAnnotation(dropPin2)
        mapView.showAnnotations(self.mapView.annotations, animated: true)
        
        
        mapView.delegate = self
        
        // Connect all the mappoints using Poly line.
        
        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        
        for annotation in mapView.annotations {
            points.append(annotation.coordinate)
        }
        
        
        let polyline = MKGeodesicPolyline(coordinates: points, count: points.count)
        
        mapView.add(polyline)
        
        mapView.camera.altitude *= 50.0;
        
    }
    
    //MARK:- MapViewDelegate methods
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        
        if overlay is MKGeodesicPolyline {
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 5
            
        }
        return polylineRenderer
    }
}
