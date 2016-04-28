//
//  udacityApi.swift
//  onTheMap
//
//  Created by kavita patel on 4/22/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import Foundation
import UIKit

class UdacityApi : ParseStudentLocation
{
    
    var userID: String?
    var name: Name?
    struct Name
    {
        var first = ""
        var last = ""
        var fullname: String
        {
            return "\(first) \(last)"
        }
    }
    //Udacity Email Login
    func login (userEmail: String, password: String, completion: (NSDictionary?, NSError?) -> Void)
    {
        let request = NSMutableURLRequest(URL: NSURL(string: "\(SESSION_URL)")!)
        let httpBodyText = "{\"udacity\": {\"username\": \"\(userEmail)\", \"password\": \"\(password)\"}}"
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = httpBodyText.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
         let task = session.dataTaskWithRequest(request) { data, response, error in
            if data != nil
            {
              let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
              if error != nil
                {
                    completion(nil, error)
                }
                else
                {
                    self.parsedResult(newData, completionHandler: { (result, err) in
                        completion(result, nil)
                    })
                }
            }
            else
            {
                completion(nil,nil)
            }
        }
        task.resume()
    }
    
    //After successful login, get User data
    func getStudent(studentid: String, completionHandler: (NSDictionary?, NSError?) -> Void)
    {
        let request = NSMutableURLRequest(URL: NSURL(string: "\(USER_URL)\(studentid)")!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
        if data != nil
        {
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            if error != nil
            {
                completionHandler(nil, error)
            }
            else
            {
                self.parsedResult(newData, completionHandler: { (result, err) in
                    completionHandler(result, nil)
                })
            }
        }
        else
        {
            completionHandler(nil, nil)
        }
        }
        task.resume()
    }
    //If user has signed up Udacity with facebook than Login
    func fbLogin (token: String, completion: (NSData?, NSError?) -> Void)
    {
        let request = NSMutableURLRequest(URL: NSURL(string: "\(SESSION_URL)")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"facebook_mobile\": {\"access_token\": \"\(token)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if data != nil
            {
             completion(data, error)
            }
            else
            {
              completion(nil, nil)
            }
        }
        task.resume()
    }
        
    func logout()
    {
        if FBSDKAccessToken.currentAccessToken() != nil
        {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
        }
        let request = NSMutableURLRequest(URL: NSURL(string: "\(SESSION_URL)")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as [NSHTTPCookie]! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                return
            }
        }
        task.resume()
    }
    //Get 100 Students in order
    func loadStudents(loadStudentsCompletion: (NSData?, NSURLResponse?, NSError?)->Void)
    {
        let request = NSMutableURLRequest(URL: NSURL(string: "\(BASE_URL)?limit=100&order=-updatedAt")!)
        request.addValue("\(ParseAPIId)", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("\(ParseAPIKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            loadStudentsCompletion(data, response, error)
        }
        task.resume()
    }
    
      
}