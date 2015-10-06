//
//  MapViewController.swift
//  nav_test
//
//  Created by mac on 9/15/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Alamofire

class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    var dispensaries = [Dispensary]()
    var cameraLocation: CLLocationCoordinate2D?
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var locationArray = [CLLocation]()
    var mapView : GMSMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView = GMSMapView()
        print("setting GMSMapViewDelegate")
        self.mapView!.delegate = self
        mapView!.myLocationEnabled = true
        mapView!.settings.myLocationButton = true
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        currentLocation = locationManager.location
        
        drawMarkersForDispensariesNear(currentLocation!.coordinate.latitude, longitude: currentLocation!.coordinate.longitude)
        self.view = self.mapView
        
        
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        //print("here")
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView!.myLocationEnabled = true
            mapView!.settings.myLocationButton = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView!.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        dispatch_async(dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("ShowMenu", sender: marker)
        }
    }
    
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        mapView.selectedMarker = marker
        return true
    }
    
    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
        //print("here at markerInfoWindow function")
        let infoWindow = NSBundle.mainBundle().loadNibNamed("CustomInfoWindow", owner: self, options: nil).first! as! CustomInfoWindow
        let dispensaryForMarker = marker.userData as! Dispensary
        infoWindow.dispensaryName.text = dispensaryForMarker.name
        infoWindow.dispensaryAddress.text = dispensaryForMarker.address
        //infoWindow.dispensaryNumber.text = dispensaryForMarker.phone
        
        let url = NSURL(string: dispensaryForMarker.logo)
        let data = NSData(contentsOfURL: url!)
        infoWindow.dispensaryLogo.image = UIImage(data: data!)
        
        let distance = dispensaryForMarker.distance!
        let distanceRounded = Double(round(10 * distance) / 10)
        infoWindow.dispensaryDistance.text = String(distanceRounded) + " mi"
        
        return infoWindow
        
    }
    
    func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
        mapView.selectedMarker = nil;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func drawMarkersForDispensariesNear(latitude: Double, longitude: Double) {
        print(latitude)
        print(longitude)
        let string = "http://lithubb.herokuapp.com/dispensaries?lat=\(latitude)&lng=\(longitude)"
        //print(string)
        Alamofire.request(.GET, string)
            .responseJSON { request, response, result in
                switch result {
                    case .Success(let data):
                        let arrayOfDispensaries = JSON(data)
                        //print(arrayOfDispensaries)
                        for var i = 0; i < arrayOfDispensaries.count; ++i {
                            let dispensaryID = arrayOfDispensaries[i]["id"].int
                            let dispensaryName = arrayOfDispensaries[i]["name"].string
                            let dispensaryLat = arrayOfDispensaries[i]["lat"].double
                            let dispensaryLng = arrayOfDispensaries[i]["lng"].double
                            let dispensaryAdd = arrayOfDispensaries[i]["address"].string
                            let dispensaryState = arrayOfDispensaries[i]["State"].string
                            let dispensaryCity = arrayOfDispensaries[i]["City"].string
                            let dispensaryPhone = arrayOfDispensaries[i]["phone"].string
                            let dispensaryLogo = arrayOfDispensaries[i]["logo"].string
                            
                            //distance set to maxRadius on node backend = 5000
                            let dispensaryDistance = arrayOfDispensaries[i]["distance"].double
                            
                            let dispensary = Dispensary(id: dispensaryID!, name: dispensaryName!, address: dispensaryAdd!, city: dispensaryCity!, state: dispensaryState!, phone: dispensaryPhone!, logo: dispensaryLogo!)
                            dispensary.latitude = dispensaryLat!
                            dispensary.longitude = dispensaryLng!
                            dispensary.distance = dispensaryDistance!
                            
                            self.dispensaries.append(dispensary)
                            //draw markers
                            let marker = GMSMarker()
                            marker.position = CLLocationCoordinate2D(latitude: dispensary.latitude!, longitude: dispensary.longitude!)
                            //marker.icon = GMSMarker.markerImageWithColor(UIColor(hue: 0.3861, saturation: 0.6, brightness: 1, alpha: 1.0))
                            marker.icon = GMSMarker.markerImageWithColor(UIColor(red: 0, green: 0.8, blue: 0.2, alpha: 1.0))
                            //marker.title = dispensary.name
                            marker.userData = dispensary
                            marker.infoWindowAnchor = CGPointMake(0.44, 0.36)
                            marker.map = self.mapView
                            
                            
                        }
                    case .Failure(_, let error):
                        print("Request failed with error: \(error)")
                    
                }
            }
    }
    
//    func getDistanceOfDispensariesWhere(Double: latitude, Double: longitude) {
//        
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMenu"{
            let menuViewController = segue.destinationViewController as! MenuViewController
            let marker = sender as! GMSMarker
            menuViewController.myMarker = marker
        }
    }

    
    func parseJSON(inputData: NSData) -> NSArray? {
        do {
            var arrOfObjects = try NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers) as! NSArray
            return arrOfObjects
        } catch {
            print(error)
            return nil
        }
    }
}


