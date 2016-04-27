//
//  mapViewController.swift
//  onTheMap
//
//  Created by kavita patel on 4/21/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit
import MapKit

class mapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let user = udacityClient()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "On The Map"
        mapView.delegate = self

    }
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        refreshData()
    }
    func refreshData()
    {
        mapView.removeAnnotations(self.mapView.annotations)
        locationAuthStatus()
       // parseStudentLocation.sharedInstance.studentInformations.removeAll()
        var annotations = [MKPointAnnotation]()
        parseStudentLocation.sharedInstance.getStudentLocation
        { (data, err) in
            if err == nil
            {
                if let list = data!["results"] as? [[String: AnyObject]]
                {
                    for result in list
                    {
                        let listobj = studentInformation(result: result)
                        parseStudentLocation.sharedInstance.locations.append(listobj)
                        let lat = CLLocationDegrees(listobj.latitude)
                        let long = CLLocationDegrees(listobj.longitude)
                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = coordinate
                        annotation.title = "\(listobj.firstName) \(listobj.lastName)"
                        annotation.subtitle = listobj.mediaURL
                        annotations.append(annotation)
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        self.mapView.addAnnotations(annotations)
                    }
                }
            }
            else
            {
                self.alertMsg("Student Info", msg: err!.description )
            }
        }
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        if control == view.rightCalloutAccessoryView
        {
            let urlStr = view.annotation?.subtitle
            if urlStr == nil
            {
                alertMsg("Link Error", msg: "Student's Link is Nil" )
            }
            else
            {
                let url = NSURL(string: (urlStr)!!)
                if UIApplication.sharedApplication().canOpenURL(url!)
                {
                      UIApplication.sharedApplication().openURL(url!)
                }
                else
                {
                    alertMsg("Link Error", msg: "Student's Link is Not Valid Formar" )
                }
            }
        }
    }
    @IBAction func refreshBtn(sender: AnyObject)
    {
        refreshData()
    }
    func locationAuthStatus()
    {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse
        {
            mapView.showsUserLocation = true
        }
        else
        {
       locationManager.requestWhenInUseAuthorization()
        }
    }
    @IBAction func addPinLocation(sender: AnyObject)
    {
        performSegueWithIdentifier("newPinSegue", sender: sender)
    }
    
    @IBAction func logOutBtnPressed(sender: AnyObject)
    {
        let udacityObj = udacityApi()
        udacityObj.logout()
        dismissViewControllerAnimated(true, completion: nil)
    }
    func alertMsg(title: String, msg: String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
