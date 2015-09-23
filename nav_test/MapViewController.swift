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
    var locationArray = [CLLocation]()
    var mapView = GMSMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        //locationManager.requestWhenInUseAuthorization()
       // locationManager.desiredAccuracy = kCLLocationAccuracyBest
       // locationManager.distanceFilter = 2000
        //locationManager.startUpdatingLocation()
        
        //mapView.myLocationEnabled = true
        //print("location enabled")
        //mapView.settings.myLocationButton = true
        //cameraLocation = locationManager.location?.coordinate
//        if var cameraLocation = locationManager.location?.coordinate {
//            print("Camera location was set by the location manager")
//            let camera = GMSCameraPosition.cameraWithLatitude(cameraLocation.latitude, longitude: cameraLocation.longitude, zoom: 15)
//            cameraLocation = CLLocationCoordinate2D(latitude: camera.target.latitude, longitude: camera.target.longitude)
//            mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
//            
//        } else {
//            print("camera location could not be set by location manager, reverting to defaults")
//            //let camera = GMSCameraPosition.cameraWithLatitude(47.610377, longitude: -122.2006786, zoom: 15)
//            //cameraLocation = CLLocationCoordinate2D(latitude: camera.target.latitude, longitude: camera.target.longitude)
//            //mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
//        }
        
        self.view = mapView
        mapView.delegate = self
        print("delegated mapview")
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMenu"{
            let menuViewController = segue.destinationViewController as! MenuViewController
            let marker = sender as! GMSMarker
            menuViewController.myMarker = marker
        }
    }
    
    
    func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
        if locationArray.last?.distanceFromLocation(CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)) > 6437.38 {
            locationArray.append(CLLocation(latitude: position.target.latitude, longitude: position.target.longitude))
            mapView.clear()
            getNearbyDispensaries(position.target)
                for dispensary in dispensaries {
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: dispensary.latitude!, longitude: dispensary.longitude!)
                    marker.title = dispensary.name
                    marker.snippet = "Monday-Saturday 10AM - 10PM | Sunday 10AM-7PM"
                    marker.map = mapView
                    marker.userData = dispensary.id
                
                }

        } else {
            locationArray.append(CLLocation(latitude: position.target.latitude, longitude: position.target.longitude))
            mapView.clear()
            getNearbyDispensaries(position.target)
            for dispensary in dispensaries {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: dispensary.latitude!, longitude: dispensary.longitude!)
                marker.title = dispensary.name
                marker.snippet = "Monday-Saturday 10AM - 10PM | Sunday 10AM-7PM"
                marker.map = mapView
                marker.userData = dispensary.id
                
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNearbyDispensaries(userLocation: CLLocationCoordinate2D) {
        let string = "http://192.168.1.145:7000/dispensaries?lat=\(userLocation.latitude)&lng=\(userLocation.longitude)"
        //print(string)
        Alamofire.request(.GET, string)
            .response { request, response, data, error in
                let arrOfDispensaries : JSON
                if (data != nil) {
                    arrOfDispensaries = JSON(data: data!)
                    for var i = 0; i < arrOfDispensaries.count; ++i {
                        let dispensaryID = arrOfDispensaries[i]["id"].int
                        let dispensaryName = arrOfDispensaries[i]["name"].string
                        let dispensaryLat = arrOfDispensaries[i]["lat"].double
                        let dispensaryLng = arrOfDispensaries[i]["lng"].double
                        let dispensaryAdd = arrOfDispensaries[i]["address"].string
                        let dispensaryState = arrOfDispensaries[i]["State"].string
                        let dispensaryCity = arrOfDispensaries[i]["City"].string
                        let dispensaryPhone = arrOfDispensaries[i]["phone"].string
                        let dispensaryLogo = arrOfDispensaries[i]["logo"].string
                        let dispensary = Dispensary(id: dispensaryID!, name: dispensaryName!, address: dispensaryAdd!, city: dispensaryCity!, state: dispensaryState!, phone: dispensaryPhone!, logo: dispensaryLogo!)
                        dispensary.latitude = dispensaryLat!
                        dispensary.longitude = dispensaryLng!
                        self.dispensaries.append(dispensary)
                        
                    }
                } else {
                    print(error)
                }
                
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


