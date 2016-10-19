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
        var planeAnnotation: MKPointAnnotation!
        var planeAnnotationPosition = 0
    var polyline:MKGeodesicPolyline!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let schipholAirport = CLLocation(latitude: 52.3094593, longitude: 4.7600949)
        let currentAirport = CLLocation(latitude: (airport?.latitude)!, longitude: (airport?.longitude)!)
        let distanceInMeters = schipholAirport.distance(from: currentAirport)
        let regionRadius: CLLocationDistance = distanceInMeters

        nameLabel.text = airport?.name
        distanceLabel.text = String(schipholAirport.distance(from: currentAirport) / 1000) + "km";

        func centerMapOnLocation(location: CLLocation){
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        
        centerMapOnLocation(location: currentAirport)
        
        let avgLat = (schipholAirport.coordinate.latitude + currentAirport.coordinate.latitude)/2
        let avglon = (schipholAirport.coordinate.longitude + currentAirport.coordinate.longitude)/2
        
        let avgcoor = CLLocationCoordinate2D(latitude: avgLat, longitude: avglon);

        
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
//        mapView.showAnnotations(self.mapView.annotations, animated: true)
        

        
        mapView.delegate = self
        
        // Connect all the mappoints using Poly line.
        
        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        
        for annotation in mapView.annotations {
            points.append(annotation.coordinate)
        }
        
        mapView.setCenter(avgcoor, animated: true)
        
        polyline = MKGeodesicPolyline(coordinates: points, count: points.count)
        
        mapView.add(polyline)
        
        let annotation = CustomPlaneAnnotation()
        annotation.title = NSLocalizedString("Plane", comment: "Plane marker")
        mapView.addAnnotation(annotation)
        
        self.planeAnnotation = annotation
        self.updatePlanePosition()
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let planeIdentifier = "Plane"
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: planeIdentifier) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: planeIdentifier)
        
        if annotation is CustomPlaneAnnotation {
            annotationView.image = UIImage.init(named: "rsz_airplane-2.png")

            return annotationView
        }
        //self.view.addSubview(annotationView)
        return nil
    }
    
    func updatePlanePosition() {
        let step = 25
        guard planeAnnotationPosition + step < polyline.pointCount
            else { return }
        
        let points = polyline.points()
        self.planeAnnotationPosition += step
        let nextMapPoint = points[planeAnnotationPosition]
        
        self.planeAnnotation.coordinate = MKCoordinateForMapPoint(nextMapPoint)
        
        perform(#selector(DetailViewController.updatePlanePosition), with: nil, afterDelay: 0.03)
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
