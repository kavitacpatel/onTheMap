//
//  tableViewController.swift
//  onTheMap
//
//  Created by kavita patel on 4/21/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit

class tableViewController: UITableViewController
{
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let locationParsingObj = parseStudentLocation()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.title = "On The Map"
    }
    override func viewDidAppear(animated: Bool)
    {
      super.viewDidAppear(animated)
      refreshData()
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return locationParsingObj.studentInformations.count
    }

    @IBAction func newPinPostBtn(sender: AnyObject)
    {
        performSegueWithIdentifier("newPinSegue", sender: sender)
    }
    @IBAction func refreshBtn(sender: AnyObject)
    {
        refreshData()
    }
    @IBAction func logOutBtnPressed(sender: AnyObject)
    {
        let udacityObj = udacityApi()
        udacityObj.logout()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as? tableViewCell
        {
            cell.configCell(locationParsingObj.studentInformations[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let url = NSURL(string: locationParsingObj.studentInformations[indexPath.row].mediaURL)
        UIApplication.sharedApplication().openURL(url!)
    }
    func refreshData()
    {
        locationParsingObj.studentInformations.removeAll()
        locationParsingObj.getStudentLocation({ (data) in
            do
            {
                let locationData = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary
                if let list = locationData!["results"] as? [[String: AnyObject]]
                {
                    for result in list
                    {
                        let listobj = studentInformation(result: result)
                        self.locationParsingObj.studentInformations.append(listobj)
                    }
                }
            }
            catch let err as NSError
            {
                print(err.description)
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        })
        
    }

  }
