//
//  tableViewController.swift
//  onTheMap
//
//  Created by kavita patel on 4/21/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController
{
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let parseObj = parseStudentLocation()
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
        return clientClass.sharedInstance.locations.count
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
            cell.configCell( clientClass.sharedInstance.locations[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let url = NSURL(string: ( clientClass.sharedInstance.locations[indexPath.row].mediaURL))
        if url == nil
        {
            alertMsg("Link Error", msg: "Student's Link is Nil" )
        }
        else
        {
          if UIApplication.sharedApplication().canOpenURL(url!)
            {
                UIApplication.sharedApplication().openURL(url!)
            }
            else
            {
                alertMsg("Link Error", msg: "Invalid Format Of Shared Link" )
            }
        }
    }
    func refreshData()
    {
         parseObj.getStudentLocation { (data, err) in
            if err == nil
            {
                dispatch_async(dispatch_get_main_queue())
                {
                    self.tableView.reloadData()
                }
            }
            else
            {
               self.alertMsg("List Error", msg: (err?.description)! )
            }
            
        }
    }
    func alertMsg(title: String, msg: String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

  }
