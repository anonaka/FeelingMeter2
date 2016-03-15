//
//  FmManagementViewController.swift
//  FeelingMeter2
//
//  Created by 野中 哲 on 2016/03/14.
//  Copyright © 2016年 TrueLogic. All rights reserved.
//

import UIKit

class FmManagementViewController: UIViewController {

    var fmModel: FmModel!
    
    @IBOutlet weak var deleteOneButton: UIButton!
    @IBOutlet weak var deleteAllButton: UIButton!
    
    @IBAction func deleteLastOne(sender: AnyObject) {
        fmModel.deleteLastFeelingData()
        let alertController = UIAlertController(
            title: NSLocalizedString("Deleted",comment: "dialog title"),
            message: NSLocalizedString("One data deleted",comment:"one data deleted confirmation"),
            preferredStyle: UIAlertControllerStyle.Alert
        )
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deleteAll(sender: AnyObject) {
        let alertController = UIAlertController(
            title: NSLocalizedString("Delete all?", comment: "dialog title"),
            message: NSLocalizedString("all the data will be deleteed",comment:"dialog message"),
            preferredStyle: UIAlertControllerStyle.Alert
        )
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel",comment:"Cancel button"), style: .Default, handler: nil)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK",comment:"OK"), style: .Default) {
            action in self.fmModel.deleteAllFeelingData()
        }

        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
}
