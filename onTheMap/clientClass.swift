//
//  clientClass.swift
//  onTheMap
//
//  Created by kavita patel on 4/28/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import Foundation

class clientClass: AnyObject
{
    static let sharedInstance = clientClass()
    var locations: [studentInformation]
     init()
     {
        locations = [studentInformation]()
    }
}