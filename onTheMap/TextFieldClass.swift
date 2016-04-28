//
//  textFieldClass.swift
//  onTheMap
//
//  Created by kavita patel on 4/23/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit

class TextFieldClass: UITextField {

    override func awakeFromNib() {
        
        let textAttributes = [
            NSForegroundColorAttributeName : UIColor.blackColor(),
            NSFontAttributeName : UIFont(name: "Arial", size: 25)!,
        ]
        self.defaultTextAttributes = textAttributes
        self.font = UIFont.boldSystemFontOfSize(25)
        self.textAlignment = NSTextAlignment.Center
        self.autocapitalizationType = UITextAutocapitalizationType.Sentences
           }

}
