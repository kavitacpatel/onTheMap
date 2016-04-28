//
//  tableViewCell.swift
//  onTheMap
//
//  Created by kavita patel on 4/22/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var listLbl: LabelClass!
    
    func configCell(studentObj: StudentInformation)
    {
          listLbl.text = studentObj.firstName + " " + studentObj.lastName
    }
}
