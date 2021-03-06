//
//  postPinViewController.swift
//  onTheMap
//
//  Created by kavita patel on 4/23/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import MapKit
import UIKit

class PostPinViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate
{

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var findOnMapBtn: UIButton!
    @IBOutlet weak var shareLinkTxt: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var studyLbl: UILabel!
    @IBOutlet weak var locationTxt: UITextField!
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    var Id: String?
    let user = UdacityClient()
    let annotation = MKPointAnnotation()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        activityInd.hidesWhenStopped = true
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        let studentObj = ParseStudentLocation()
        studentObj.existsStudentLocation(UdacityClient.Client.uniqueKey) { (data, error)-> Void in
               if error == nil
               {
                    if data != nil
                    {
                        if let dictionary = data as? [String: AnyObject]
                        {
                            let result = dictionary["results"] as? [[String: AnyObject]]
                            if result?.count > 0
                            {
                            UdacityClient.Client.objectId = result![0]["objectId"] as! String
                            self.Id =  UdacityClient.Client.objectId
                            }
                        }
                    }
                   else
                    {
                        self.alertMsg("Connection Error", msg: "Connection Not Found")
                        self.setHIdden(true)
                    }
                }
            else
            {
                self.alertMsg("exists student", msg: error!.description)
                self.setHIdden(true)
            }
        }
        
    }
    @IBAction func cancelBtnPressed(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func setHIdden(value: Bool)
    {
        backView.hidden = !value
        studyLbl.hidden = !value
        findOnMapBtn.hidden = !value
        locationTxt.hidden = !value
        shareLinkTxt.hidden = value
        mapView.hidden = value
        submitBtn.hidden = value

    }
    @IBAction func findOnMapBtnPressed(sender: AnyObject)
    {
        //find location on map
        if UdacityClient.Client.objectId != ""
        {

           let alert = UIAlertController(title: "Update?", message: "You Already Have a Location. Do You Want To Overwrite?", preferredStyle: .Alert)
           let updateAction = UIAlertAction(title: "Overwrite", style: .Default)
           { (action) in
              UdacityClient.Client.mapString = self.locationTxt.text!
              self.overWriteData()
            }
           let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action) in
            
           }
            alert.addAction(updateAction)
            alert.addAction(cancelAction)
            dispatch_async(dispatch_get_main_queue())
             {
                 self.presentViewController(alert, animated: true, completion: nil)
             }
        }
        else
        {
            UdacityClient.Client.mapString = self.locationTxt.text!
            self.overWriteData()
        }
        
    }
    
    func overWriteData()
    {
        //Overwrite location if user already have it
        if locationTxt.text != nil
        {
            activityInd.hidden = false
            activityInd.startAnimating()
            CLGeocoder().geocodeAddressString(locationTxt.text!, completionHandler: { (placeMark: [CLPlacemark]?,err: NSError?)-> Void in
                if err == nil
                {
                    let coordinate = placeMark![0].location?.coordinate
                    if (!CLLocationCoordinate2DIsValid(coordinate!))
                    {
                        self.alertMsg("FindOnMap-Error", msg: "Please Enter Valid Location.")
                        self.activityInd.hidden = true
                        self.activityInd.stopAnimating()
                        return
                    }
                    self.activityInd.hidden = true
                    self.activityInd.stopAnimating()
                    self.annotation.coordinate = coordinate!
                    self.annotation.subtitle = self.shareLinkTxt.text
                    self.annotation.title = ""
                    UdacityClient.Client.mapString = self.locationTxt.text!
                    UdacityClient.Client.latitude = coordinate!.latitude as Double
                    UdacityClient.Client.longitude = coordinate!.longitude as Double
                    self.mapView.addAnnotations([self.annotation])
                    //Zoom on location
                    let region = MKCoordinateRegionMakeWithDistance(coordinate!, 2000, 2000)
                    self.mapView.setRegion(region, animated: true)
                    self.setHIdden(false)
                }
                else
                {
                    self.alertMsg("FindOnMap-Error", msg: "Connection Not Found")
                    self.activityInd.hidesWhenStopped = true
                }
            })
        }
        else
        {
            alertMsg("FindOnMap-Error", msg: "Please Enter Location.")
        }

    }

    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func submitBtnPressed(sender: AnyObject)
    {
        //submit location
        if validUrl(shareLinkTxt.text!) && shareLinkTxt.text != nil
        {
                       UdacityClient.Client.mediaURL = self.shareLinkTxt.text!
                        let clientDict = self.user.clientDict(UdacityClient.Client.first, last: UdacityClient.Client.last, latitude: UdacityClient.Client.latitude, longitude: UdacityClient.Client.longitude, mapstring: UdacityClient.Client.mapString, mediaurl: UdacityClient.Client.mediaURL, objectid: UdacityClient.Client.objectId, uniqueid: UdacityClient.Client.uniqueKey) as NSDictionary
                        let saveLocation = ParseStudentLocation()
                        if let objectId = self.Id
                        {
                            // if user exists than update
                            saveLocation.putStudentLocation(objectId, data: clientDict as! [String : AnyObject], completionHandler: { (result, error) in
                                if error == nil
                                {
                                    if result  != nil
                                    {
                                        dispatch_async(dispatch_get_main_queue())
                                        {
                                            self.dismissViewControllerAnimated(true, completion: nil)
                                            self.alertMsg("Location", msg: "New Location Added Successfully")
                                            self.setHIdden(true)
                                        }
                                    }
                                    else
                                    {
                                        dispatch_async(dispatch_get_main_queue())
                                        {
                                            self.alertMsg("Connection Error", msg: "Connection Not Found")
                                        }
                                    }
                                }
                                else
                                {
                                    self.alertMsg("Location", msg: "Connection Not Found")
                                }
                            })
                        }
                        else
                        {
                            saveLocation.postStudentLocation(clientDict as! [String : AnyObject], completionHandler: { (result, error) in
                                if error == nil
                                {
                                    if result != nil
                                    {
                                        dispatch_async(dispatch_get_main_queue())
                                        {
                                            self.dismissViewControllerAnimated(true, completion: nil)
                                            self.alertMsg("Location", msg: "New Location Added Successfully")
                                             self.setHIdden(true)
                                        }
                                    }
                                    else
                                    {
                                        dispatch_async(dispatch_get_main_queue())
                                        {
                                            self.alertMsg("Connection Error", msg: "Connection Not Found")
                                        }
                                    }
                                }
                                else
                                {
                                    self.alertMsg("Location", msg: "Connection Not Found")
                                }
                            })
                        }
                   }
        else
        {
          alertMsg("Link-Error", msg: "Enter Valid Url Link in HTTP Format.")
        }
    }
    func validUrl(scheme: String) -> Bool {
        if let url = NSURL.init(string: scheme) {
            return UIApplication.sharedApplication().canOpenURL(url)
        }
        return false
    }
    func alertMsg(title: String, msg: String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
