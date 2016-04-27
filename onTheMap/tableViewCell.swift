//
//  tableViewCell.swift
//  onTheMap
//
//  Created by kavita patel on 4/22/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit

class tableViewCell: UITableViewCell {

    @IBOutlet weak var listLbl: labelClass!
    
    func configCell(studentObj: studentInformation)
    {
          listLbl.text = studentObj.firstName + " " + studentObj.lastName
    }
}
