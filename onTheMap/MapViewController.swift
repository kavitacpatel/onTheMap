//
//  mapViewController.swift
//  onTheMap
//
//  Created by kavita patel on 4/21/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let user = udacityClient()
    let parseObj = parseStudentLocation()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.title = "On The Map"
        mapView.delegate = self
        activityInd.hidden = false
    }
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        activityInd.hidden = true
        activityInd.startAnimating()
        refreshData()
    }
    
    func mapViewDidFinishLoadingMap(mapView: MKMapView)
    {
        activityInd.hidden = false
        activityInd.stopAnimating()
    }
    func mapViewDidFailLoadingMap(mapView: MKMapView, withError error: NSError)
    {
        activityInd.hidden = true
        activityInd.startAnimating()
    }
    
    func refreshData()
    {
        mapView.removeAnnotations(self.mapView.annotations)
        locationAuthStatus()
        var annotations = [MKPointAnnotation]()
        parseObj.getStudentLocation
        { (data, err) in
            if err == nil
            {
                if let list = data!["results"] as? [[String: AnyObject]]
                {
                    for result in list
                    {
                        let listobj = studentInformation(result: result)
                        clientClass.sharedInstance.locations.append(listobj)
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
        activityInd.stopAnimating()
        activityInd.hidden = true
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
            if (view.annotation?.subtitle)! != nil
            {
              let urlStr: String? = ((view.annotation?.subtitle)!)!
              let url = NSURL(string: (urlStr)!)
                if UIApplication.sharedApplication().canOpenURL(url!)
                {
                      UIApplication.sharedApplication().openURL(url!)
                }
                else
                {
                    alertMsg("Link Error", msg: "Student's Link is Not Valid Formar" )
                }
            }
            else
                {
                    alertMsg("Link Error", msg: "Student's Link is Nil" )
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
        activityInd.stopAnimating()
    }
}
