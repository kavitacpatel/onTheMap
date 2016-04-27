//
//  studentLocation.swift
//  onTheMap
//
//  Created by kavita patel on 4/22/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import Foundation

   struct studentInformation {
        var firstName: String
        var lastName: String
        var latitude: Double
        var longitude: Double
        var mapString: String
        var mediaURL: String
        var objectId: String
        var uniqueKey: String
        
        init(result: NSDictionary )
        {
            firstName = result.valueForKeyPath("firstName") as! String
            lastName = result.valueForKeyPath("lastName") as! String
            longitude = result.valueForKeyPath("longitude") as! Double
            latitude = result.valueForKeyPath("latitude") as! Double
            mapString = result.valueForKeyPath("mapString") as! String
            mediaURL = result.valueForKeyPath("mediaURL") as! String
            objectId = result.valueForKeyPath("objectId") as! String
            uniqueKey = result.valueForKeyPath("uniqueKey") as! String
            
        }
       static func locationsFromResults(results: [[String : AnyObject]]) -> [studentInformation]
       {
         var locations = [studentInformation]()
         for result in results
         {
            locations.append(studentInformation(result: result))
         }
        return locations
    }
        
}

    