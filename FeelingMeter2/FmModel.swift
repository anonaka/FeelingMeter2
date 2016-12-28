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
    func getColor(_ i: Int) -> UIColor
    func getText(_ i: Int) -> String
}
class FmModel : FmGraphDataSource
{
    let MAX_DATA_LIMIT = 30
    struct FeelingItem {
        var date: Date
        var feeling: Int
        
        init(feeling: Int){
            self.date = Date()
            self.feeling = feeling
        }
        
        init(date: Date, feeling: Int){
            self.date = date
            self.feeling = feeling
        }
    }
    struct FeelingType {
        let color: UIColor
        let message: String
    }
    
    let feelingTypes: [FeelingType] = [
        FeelingType(color: UIColor.red, message: NSLocalizedString("Feeling Red", comment: "Home view string")),
        FeelingType(color: UIColor.orange, message: NSLocalizedString("Feeling Orange", comment: "Home view string")),
        FeelingType(color: UIColor.green, message: NSLocalizedString("Feeling Green", comment: "Home view string")),
        FeelingType(color: UIColor.cyan, message: NSLocalizedString("Feeling Light Blue", comment: "Home view string")),
        FeelingType(color: UIColor.blue, message: NSLocalizedString("Feeling Blue", comment: "Home view string"))
    ]
    
    var gvController: FmGraphRootViewController? = nil
    
    var feelings: [FeelingItem] = []
    let managedContext: NSManagedObjectContext
    let entityName = "FeelingStore"
    
    init(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.managedObjectContext
    
        fetchFeelingData()
    }
    
    func getNumOfFeelings() -> Int {
        return feelingTypes.count
    }
    
    func getFeelingData() -> [FmModel.FeelingItem]{
        return feelings
    }
    
    func getColor(_ i: Int) -> UIColor {
       return feelingTypes[i].color
    }
    
    func getText(_ i: Int) -> String {
        return feelingTypes[i].message
    }
    
    func addFeeling(_ feeling: Int)
    {
        let item = FeelingItem(feeling: feeling)
        feelings.append(item)
        if MAX_DATA_LIMIT < feelings.count {
            deleteFirstFeelingData()
        }
        saveFeelingData(item)
    }
    
    func saveFeelingData(_ item: FeelingItem){
        let entity =  NSEntityDescription.entity(forEntityName: entityName,
            in: self.managedContext)
 
        let feeling = NSManagedObject(entity: entity!,
            insertInto: self.managedContext)
        
        feeling.setValue(item.date, forKey: "date")
        feeling.setValue(item.feeling, forKey: "feeling")

        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    // TODO: refacor delete frist, last, all
    func deleteLastFeelingData(){
        if feelings.count == 0 {
            return
        }
        
        gvController?.setNeedsUpdate()
        
        feelings.removeLast()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let results = try managedContext.fetch(fetchRequest)
            // remove the last data
            let firstStoredData = results.last
            managedContext.delete(firstStoredData as! NSManagedObject)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func deleteFirstFeelingData(){
        feelings.removeFirst()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let results = try managedContext.fetch(fetchRequest)
                // remove the first data
                let firstStoredData = results.first
                managedContext.delete(firstStoredData as! NSManagedObject)
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    func deleteAllFeelingData(){
        gvController?.setNeedsUpdate()
        feelings = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(deleteRequest)
        } catch let error as NSError {
            print("Could not delete \(error), \(error.userInfo)")
        }
    }
    
    func fetchFeelingData(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FeelingStore")
        
         do {
            let results = try managedContext.fetch(fetchRequest)
            for elem in results {
                let date = (elem as AnyObject).value(forKey: "date") as! Date
                let feeling = (elem as AnyObject).value(forKey: "feeling") as! Int
                feelings.append(FmModel.FeelingItem(date: date,feeling: feeling))
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
}
