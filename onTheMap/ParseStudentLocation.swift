//
//  parseStudentLocation.swift
//  onTheMap
//
//  Created by kavita patel on 4/22/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import Foundation

class ParseStudentLocation: NSObject
{
   
    func getStudentLocation(completionHandler: (data: NSDictionary?, err: NSError?) -> Void )
   {
        let request = NSMutableURLRequest(URL: NSURL(string: "\(BASE_URL)?order=-updatedAt")!)
        request.addValue("\(ParseAPIId)", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("\(ParseAPIKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
           if data == nil
           {
               completionHandler(data: nil, err: nil)
            }
            else if error != nil
            {
                completionHandler(data: nil, err: error)
            }
            
           else
            {
                self.parsedResult(data!, completionHandler: { (result, err) in
                    completionHandler(data: result, err: nil)
                })
            }
        }
        task.resume()
    }
    
    //Updating StudentLocation
     func putStudentLocation(objectId: String, data: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void ) {
        let urlString = "\(BASE_URL)/\(objectId)"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "PUT"
        request.addValue("\(ParseAPIId)", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("\(ParseAPIKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do
        {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(data, options: [])
        }
        catch
        {
            request.HTTPBody = nil
            return
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if data != nil
            {
                self.parsedResult(data!, completionHandler: { (result, err) in
                    completionHandler(result: result, error: nil)
                })
            }
            else if error != nil
            {
                completionHandler(result: nil, error: error)
            }
            else
            {
               completionHandler(result: nil, error: nil)
            }
        }
        task.resume()
    }
    
    func parsedResult(data: NSData, completionHandler: (result: NSDictionary?, err: NSError?) -> Void)
    {
        let parsedResult: NSDictionary?
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
            completionHandler(result: parsedResult!, err: nil)
        } catch let err as NSError
        {
            completionHandler(result: nil, err: err)
        }
    }
    
    // pin new location
    func postStudentLocation( data: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void ) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "\(BASE_URL)")!)
        request.HTTPMethod = "POST"
        request.addValue("\(ParseAPIId)", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("\(ParseAPIKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do
        {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(data, options: [])
        }
        catch
        {
            request.HTTPBody = nil
            return
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {data, response, error in
            if data == nil
            {
                completionHandler(result: nil, error: nil)
            }
            else if error != nil
            {
                completionHandler(result: nil, error: error)
            }
            else
            {
                completionHandler(result: data, error: nil)
            }
        }
        task.resume()
        
    }
   
    //Search if a student's location exists. It requires the unique Key
    func existsStudentLocation( uniqueKey: String, completionHandler: (data: NSDictionary?, err: NSError?) -> Void ) {
        
        let urlString = "\(BASE_URL)?where=%7B%22uniqueKey%22%3A%22\(uniqueKey)%22%7D"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue("\(ParseAPIKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("\(ParseAPIId)", forHTTPHeaderField: "X-Parse-Application-Id")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if data == nil
            {
                completionHandler(data: nil, err: nil)
            }
            else if error != nil
            {
                completionHandler(data: nil, err: error)
            }
            else
            {
                self.parsedResult(data!, completionHandler: { (result, err) in
                    completionHandler(data: result, err: nil)
                })
            }

            }
        task.resume()
    }
    
}

