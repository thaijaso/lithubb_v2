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
    var mapView = GMSMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        currentLocation = locationManager.location
        
        drawMarkersForDispensariesNear(currentLocation!.coordinate.latitude, longitude: currentLocation!.coordinate.longitude)
        
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        
        self.view = mapView
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("here")
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
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
    
    func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
        mapView.selectedMarker = nil;
    }
    //func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
//        print("idle")
//        if locationArray.last?.distanceFromLocation(CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)) > 6437.38 {
//            locationArray.append(CLLocation(latitude: position.target.latitude, longitude: position.target.longitude))
//            mapView.clear()
//            getNearbyDispensaries(position.target)
//                for dispensary in dispensaries {
//                    let marker = GMSMarker()
//                    marker.position = CLLocationCoordinate2D(latitude: dispensary.latitude!, longitude: dispensary.longitude!)
//                    marker.title = dispensary.name
//                    marker.snippet = "Monday-Saturday 10AM - 10PM | Sunday 10AM-7PM"
//                    marker.map = mapView
//                    marker.userData = dispensary.id
//                
//                }
//
//        } else {
//            locationArray.append(CLLocation(latitude: position.target.latitude, longitude: position.target.longitude))
//            mapView.clear()
//            getNearbyDispensaries(position.target)
//            for dispensary in dispensaries {
//                let marker = GMSMarker()
//                marker.position = CLLocationCoordinate2D(latitude: dispensary.latitude!, longitude: dispensary.longitude!)
//                marker.title = dispensary.name
//                marker.snippet = "Monday-Saturday 10AM - 10PM | Sunday 10AM-7PM"
//                marker.map = mapView
//                marker.userData = dispensary.id
//                
//            }
//        }
    //}
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func drawMarkersForDispensariesNear(latitude: Double, longitude: Double) {
        //print(latitude)
        //print(longitude)
        ///let string = "http://192.168.1.145:7000/dispensaries?lat=\(latitude)&lng=\(longitude)"
        let string = "http://192.168.1.146:7000/dispensaries"
        //print(string)
        Alamofire.request(.GET, string)
            .responseJSON { request, response, result in
                switch result {
                    case .Success(let data):
                        let arrayOfDispensaries = JSON(data)
                        print(arrayOfDispensaries)
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
                            let dispensary = Dispensary(id: dispensaryID!, name: dispensaryName!, address: dispensaryAdd!, city: dispensaryCity!, state: dispensaryState!, phone: dispensaryPhone!, logo: dispensaryLogo!)
                            dispensary.latitude = dispensaryLat!
                            dispensary.longitude = dispensaryLng!
                            self.dispensaries.append(dispensary)
                            //draw markers
                            let marker = GMSMarker()
                            marker.position = CLLocationCoordinate2D(latitude: dispensary.latitude!, longitude: dispensary.longitude!)
                            marker.title = dispensary.name
                            marker.userData = dispensary.id
                            marker.map = self.mapView
                            
                            
                        }
                    case .Failure(_, let error):
                        print("Request failed with error: \(error)")
                    
                }
            }
    }
    
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


