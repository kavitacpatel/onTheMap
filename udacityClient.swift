//
//  udacityClient.swift
//  onTheMap
//
//  Created by kavita patel on 4/25/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import Foundation

class udacityClient
{
    
    struct Client {
       static var first = ""
       static var last = ""
       static var latitude = 0.0
       static var longitude = 0.0
       static var mapString = ""
       static var mediaURL = ""
       static var objectId = ""
       static var uniqueKey = ""
        }
    func clientDict(first:String, last: String, latitude: Double, longitude: Double, mapstring: String, mediaurl: String, objectid: String, uniqueid: String)-> NSDictionary
    {
        
        let returnDict:NSDictionary? = [
            "firstName": first,
            "lastName": last,
            "latitude": latitude,
            "longitude": longitude,
            "mapString": mapstring,
            "mediaURL": mediaurl,
            "objectId": objectid,
            "uniqueKey": uniqueid
        ];
        return returnDict!
    }
}