//
//  ViewController.swift
//  onTheMap
//
//  Created by kavita patel on 4/15/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit



class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        clearText()
    }
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil
        {
            performSegueWithIdentifier("loggedIn", sender: nil)
            clearText()
        }
    }
    
    @IBAction func emailLoginBtnPressed(sender: AnyObject)
    {
        //Email Login
        if emailText.text == "" || passwordText.text == ""
        {
            alertMsg("Udacity Login", msg: "Please Enter Valid Email/ Password." )
            return
        }
        else
        {
            let udacityObj = UdacityApi()
            udacityObj.login(self.emailText.text!, password: self.passwordText.text!) { (data: NSDictionary?,error: NSError?)-> Void in
                  if data == nil && error == nil
                  {
                    dispatch_async(dispatch_get_main_queue())
                    {
                       self.alertMsg("Network Error", msg: "No Data Found")
                    }
                  }
                  else if error != nil
                        {
                            self.alertMsg("Udacity Login", msg: error.debugDescription )
                            return
                        }
                  else
                        {
                            dispatch_async(dispatch_get_main_queue())
                            {
                                self.returnUdacityClient(data!)
                                self.performSegueWithIdentifier("loggedIn", sender: nil)
                                self.clearText()
                            }
                        }
            }
        }
    }
    
    
    @IBAction func fbLoginBtnPressed(sender: AnyObject)
    {
        //Facebook Login
         let fbLogin = FBSDKLoginManager()
            fbLogin.logInWithReadPermissions(["email"], fromViewController: self, handler: { (fbResult: FBSDKLoginManagerLoginResult!,err:  NSError!) in
                if err != nil
                {
                    self.alertMsg("Facebook Login", msg: "Account Not Found" )
                    return
                }
                else if fbResult.isCancelled
                {
                   self.alertMsg("Facebook Login", msg: "Facebook Request has been Cancelled" )
                }
                else
                {
                    let accesstoken = FBSDKAccessToken.currentAccessToken().tokenString
                      let udacityObj = UdacityApi()
                       udacityObj.fbLogin(accesstoken, completion: { (data: NSData? ,error: NSError?) in
                        if data == nil && error == nil
                        {
                            dispatch_async(dispatch_get_main_queue())
                            {
                                self.alertMsg("Network Error", msg: "No Data Found")
                            }
                        }
                        else if error != nil
                        {
                            self.alertMsg("Facebook Login", msg: "Facebook Login Failed" )
                            return
                        }
                        dispatch_async(dispatch_get_main_queue())
                        {
                                self.returnFBUserData()
                                self.performSegueWithIdentifier("loggedIn", sender: nil)
                                self.clearText()
                        }
                    })
                }
        })
    }
    func returnFBUserData()
    {
        // return Facebook User
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, first_name, last_name"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                self.alertMsg("Facebook Login", msg: "Connection Problem." )
            }
            else
            {
                UdacityClient.Client.uniqueKey = result.valueForKey("id") as! String!
                UdacityClient.Client.first = result.valueForKey("first_name") as! String!
                UdacityClient.Client.last = result.valueForKey("last_name") as! String!
            }
        })
    }
    func returnUdacityClient(result: NSDictionary)
    {
        //retrun Udacity User
        if let error = result.valueForKeyPath("status") as? Int
        {
           if error == 403
           {
            alertMsg("Udacity Account", msg: "Account Not Found or Invalid" )
            }
        }
        else
        {
        let udacityObj = UdacityApi()
            let uniqueId  = result.valueForKeyPath("account.key") as? String
            udacityObj.getStudent(uniqueId!, completionHandler: { (result: NSDictionary?, err: NSError?) -> Void in
                if ((err) != nil)
                {
                    self.alertMsg("Udacity Login", msg: "Udacity Connection Problem" )
                }
                else
                {
                UdacityClient.Client.uniqueKey = uniqueId!
                UdacityClient.Client.first = result!.valueForKeyPath("user.first_name") as! String!
                UdacityClient.Client.last = result!.valueForKeyPath("user.last_name") as! String!
                }
            })
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    func alertMsg(title: String, msg: String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    @IBAction func signUPBtnPressed(sender: AnyObject)
    {
        let openURL = "https://www.udacity.com/account/auth#!/signup"
        UIApplication.sharedApplication().openURL(NSURL(string: openURL)!)
    }
    func  clearText()
    {
        emailText.text = ""
        passwordText.text = ""
    }
    
}

