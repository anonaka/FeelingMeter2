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
    
    
    @IBAction func deleteLastOne(_ sender: AnyObject) {
        fmModel.deleteLastFeelingData()
        let alertController = UIAlertController(
            title: NSLocalizedString("Deleted",comment: "dialog title"),
            message: NSLocalizedString("One data deleted",comment:"one data deleted confirmation"),
            preferredStyle: UIAlertControllerStyle.alert
        )
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deleteAll(_ sender: AnyObject) {
        let alertController = UIAlertController(
            title: NSLocalizedString("Delete all?", comment: "dialog title"),
            message: NSLocalizedString("all the data will be deleteed",comment:"dialog message"),
            preferredStyle: UIAlertControllerStyle.alert
        )
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel",comment:"Cancel button"), style: .default, handler: nil)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK",comment:"OK"), style: .default) {
            action in self.fmModel.deleteAllFeelingData()
        }

        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
