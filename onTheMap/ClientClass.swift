//
//  clientClass.swift
//  onTheMap
//
//  Created by kavita patel on 4/28/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import Foundation

class ClientClass: AnyObject
{
    static let sharedInstance = ClientClass()
    var locations: [StudentInformation]
    private init()
     {
        locations = [StudentInformation]()
    }
}