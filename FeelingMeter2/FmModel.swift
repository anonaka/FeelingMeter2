//
//  FmModel.swift
//  FeelingMeter2
//
//  Created by 野中 哲 on 2016/02/10.
//  Copyright © 2016年 TrueLogic. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol FmGraphDataSource
{
    func getNumOfFeelings() -> Int
    func getFeelingData() -> [FmModel.FeelingItem]
    func getColor(i: Int) -> UIColor
    func getText(i: Int) -> String
}
class FmModel : FmGraphDataSource
{
    let MAX_DATA_LIMIT = 30
    struct FeelingItem {
        var date: NSDate
        var feeling: Int
        
        init(feeling: Int){
            self.date = NSDate()
            self.feeling = feeling
        }
        
        init(date: NSDate, feeling: Int){
            self.date = date
            self.feeling = feeling
        }
    }
    struct FeelingType {
        let color: UIColor
        let message: String
    }
    
    let feelingTypes: [FeelingType] = [
        FeelingType(color: UIColor.redColor(), message: NSLocalizedString("Feeling Red", comment: "Home view string")),
        FeelingType(color: UIColor.orangeColor(), message: NSLocalizedString("Feeling Orange", comment: "Home view string")),
        FeelingType(color: UIColor.greenColor(), message: NSLocalizedString("Feeling Green", comment: "Home view string")),
        FeelingType(color: UIColor.cyanColor(), message: NSLocalizedString("Feeling Light Blue", comment: "Home view string")),
        FeelingType(color: UIColor.blueColor(), message: NSLocalizedString("Feeling Blue", comment: "Home view string"))
    ]
    
    var feelings: [FeelingItem] = []

    init(){
        fetchFeelingData()
    }
    
    func getNumOfFeelings() -> Int {
        return feelingTypes.count
    }
    
    func getFeelingData() -> [FmModel.FeelingItem]{
        return feelings
    }
    
    func getColor(i: Int) -> UIColor {
       return feelingTypes[i].color
    }
    
    func getText(i: Int) -> String {
        return feelingTypes[i].message
    }
    
    func addFeeling(feeling: Int)
    {
        let item = FeelingItem(feeling: feeling)
        feelings.append(item)
        if MAX_DATA_LIMIT < feelings.count {
            feelings.removeFirst()
            deleteFirstFeelingData()
        }
        saveFeelingData(item)
    }
    
    func saveFeelingData(item: FeelingItem){
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("FeelingStore",
            inManagedObjectContext:managedContext)
 
        let feeling = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        //3
        feeling.setValue(item.date, forKey: "date")
        feeling.setValue(item.feeling, forKey: "feeling")
        //4
        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func deleteFirstFeelingData(){
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "FeelingStore")
        
        //3
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
                // remove the first data
                let firstStoredData = results[0]
                managedContext.deleteObject(firstStoredData as! NSManagedObject)
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    
    func fetchFeelingData(){
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "FeelingStore")
        
        //3
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for elem in results {
                let date = elem.valueForKey("date") as! NSDate
                let feeling = elem.valueForKey("feeling") as! Int
                feelings.append(FmModel.FeelingItem(date: date,feeling: feeling))
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
}