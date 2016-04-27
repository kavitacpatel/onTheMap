//
//  udacityApi.swift
//  onTheMap
//
//  Created by kavita patel on 4/22/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import Foundation

import UIKit

class udacityApi : NSObject
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
    func login (userEmail: String, password: String, loginCompletion: (NSDictionary?, NSURLResponse?, NSError?) -> Void)
    {
        let request = NSMutableURLRequest(URL: NSURL(string: "\(SESSION_URL)")!)
        let httpBodyText = "{\"udacity\": {\"username\": \"\(userEmail)\", \"password\": \"\(password)\"}}"
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = httpBodyText.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            let parsedResult = (try! NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
            loginCompletion(parsedResult, response, error)
        }
        task.resume()
    }
    
    //After successful login, get User data
    func getStudent(studentid: String, completionHandler: (NSDictionary?, NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "\(USER_URL)\(studentid)")!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request)
        { data, response, error in
            if error == nil
            {
               let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
               let result = (try! NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
               completionHandler(result, error)
            }
        }
        task.resume()
    }
    //If user has signed up Udacity with facebook than Login
    func fbLogin (token: String, completion: (NSData?, NSURLResponse?, NSError?) -> Void)
    {
        let request = NSMutableURLRequest(URL: NSURL(string: "\(SESSION_URL)")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"facebook_mobile\": {\"access_token\": \"\(token)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
             completion(data, response, error)
        }
        task.resume()
    }
        
    func logout()
    {
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