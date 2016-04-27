//
//  labelClass.swift
//  onTheMap
//
//  Created by kavita patel on 4/17/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit

class labelClass: UILabel {

    override func awakeFromNib() {
        
        let _attributes = [
            NSForegroundColorAttributeName: UIColor.lightGrayColor(),
            NSFontAttributeName : "Arial"]
        self.attributedText = NSAttributedString(string: "", attributes: _attributes)
        self.font = UIFont.boldSystemFontOfSize(17)
        self.textAlignment = NSTextAlignment.Center
}
}