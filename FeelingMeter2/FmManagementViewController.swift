//
//  FmManagementViewController.swift
//  FeelingMeter2
//
//  Created by 野中 哲 on 2016/03/14.
//  Copyright © 2016年 TrueLogic. All rights reserved.
//

import UIKit

class FmManagementViewController: UIViewController {

    @IBOutlet weak var deleteOneButton: UIButton!
    @IBOutlet weak var deleteAllButton: UIButton!
    
    @IBAction func deleteOne(sender: AnyObject) {
        print("delete one")
    }
    
    @IBAction func deleteAll(sender: AnyObject) {
        print("delete all")
        
    }
    
}
