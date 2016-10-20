//
//  DetailViewController.swift
//  SQLiteCRUD
//
//  Created by FraBarTho on 13/10/2016.
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
        var planeDirection: CLLocationDirection = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        let schipholAirport = CLLocation(latitude: 52.3094593, longitude: 4.7600949)
        let currentAirport = CLLocation(latitude: (airport?.latitude)!, longitude: (airport?.longitude)!)
        let distanceInMeters = schipholAirport.distance(from: currentAirport)
        let regionRadius: CLLocationDistance = distanceInMeters

        nameLabel.text = airport?.name
        distanceLabel.text = String(schipholAirport.distance(from: currentAirport) / 1000) + "km";

        //Define centerMaOn method.
        func centerMapOnLocation(location: CLLocation){
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        
        centerMapOnLocation(location: currentAirport)
        
        //Calculate avg coordinates.
        let avgLat = (schipholAirport.coordinate.latitude + currentAirport.coordinate.latitude)/2
        let avglon = (schipholAirport.coordinate.longitude + currentAirport.coordinate.longitude)/2
        
        let avgcoor = CLLocationCoordinate2D(latitude: avgLat, longitude: avglon);

        
        // Add mappoints to Map
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = schipholAirport.coordinate
        dropPin.title = airport?.name
        mapView.addAnnotation(dropPin)
        
        let dropPin2 = MKPointAnnotation()
        dropPin2.coordinate = currentAirport.coordinate
        dropPin2.title = "Amsterdam Schiphol"
        mapView.addAnnotation(dropPin2)
        

        
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
    
    
    //Delegate for drawing the view of the annotations
    //If plane then use UIImage else use default.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let planeIdentifier = "Plane"
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: planeIdentifier) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: planeIdentifier)
        
        if annotation is CustomPlaneAnnotation {
            annotationView.image = UIImage.init(named: "rsz_airplane-2.png")
            
            annotationView.transform = mapView.transform.rotated(by: CGFloat(degreesToRadians(degrees: planeDirection)))
            
            
            //annotationView.transform = CGAffineTransformRotate(mapView.transform,degreesToRadians(planeDirection))
            
            return annotationView
        }
        return nil
    }
    
    //Update the plane position over the time.
    func updatePlanePosition() {
        let step = 25
        guard planeAnnotationPosition + step < polyline.pointCount
            else { return }
        
        let points = polyline.points()
        
        let previousMapPoint = points[planeAnnotationPosition]
        self.planeAnnotationPosition += step
        let nextMapPoint = points[planeAnnotationPosition]
        
        self.planeAnnotation.coordinate = MKCoordinateForMapPoint(nextMapPoint)
        self.planeDirection = directionBetweenPoints(sourcePoint: previousMapPoint, destinationPoint: nextMapPoint)
        perform(#selector(DetailViewController.updatePlanePosition), with: nil, afterDelay: 0.03)
        
        
    }
    
    private func directionBetweenPoints(sourcePoint: MKMapPoint,  destinationPoint: MKMapPoint) -> CLLocationDirection {
        let x = destinationPoint.x - sourcePoint.x
        let y = destinationPoint.y - sourcePoint.y
        
        var degrees = 90.0 - (radiansToDegrees(radians: atan2(y,x)));
        
        if( degrees < 0.0 )
        {
            degrees += 360.0;
        }
        return degrees;
    }
    
    private func radiansToDegrees(radians: Double) -> Double {
        return radians * 180 / M_PI
    }
    
    private func degreesToRadians(degrees: Double) -> Double {
        return degrees * M_PI / 180
    }
    
    
    //Renderer for the overlay items, in this case the GeoPolyLine.
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        
        if overlay is MKGeodesicPolyline {
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 5
            
        }
        return polylineRenderer
    }
}
