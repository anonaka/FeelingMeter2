//
//  ViewController.swift
//  FeelingMeter2
//
//  Created by 野中 哲 on 2016/02/04.
//  Copyright © 2016年 TrueLogic. All rights reserved.
//

import UIKit
import AVFoundation

class FmHomeViewController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet weak var fmScrollView: UIScrollView!

    let fmModel = FmModel()
   
    var fmHomeView: FmHomeView!
    var seletFeelingSoundId: SystemSoundID = 0
    var movePageSoundId: SystemSoundID = 0
    
    override func viewWillLayoutSubviews() {
        self.setupViews()
    }
    
    private func setupViews(){
        self.view.backgroundColor = UIColor.whiteColor()
        
        // TODO: setup sound must be done in the app init time
        
        let seletFeelingSoundURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("coin4", ofType: "mp3")!)
        AudioServicesCreateSystemSoundID(seletFeelingSoundURL, &seletFeelingSoundId)
 
        let movePageSoundURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("jump2", ofType: "mp3")!)
        AudioServicesCreateSystemSoundID(movePageSoundURL, &movePageSoundId)
       
        let size = CGSizeMake(
            self.view.frame.size.width,
            self.view.frame.size.height - self.topLayoutGuide.length);
  
        if let v = self.fmHomeView
            { v.removeFromSuperview() }
        
        self.fmHomeView = FmHomeView(size: size, dataSource: fmModel)
        let gr = UISwipeGestureRecognizer(target: self, action: "swipeLeftGesture:")
        gr.direction = UISwipeGestureRecognizerDirection.Left
        self.fmHomeView.addGestureRecognizer(gr)
        
        // add doub tap gesgure
        let gr2 = UITapGestureRecognizer(target: self, action: "doubleTapGestuer:")
        gr2.numberOfTapsRequired = 2
        self.fmHomeView.addGestureRecognizer(gr2)
        
        fmScrollView.contentSize = fmHomeView.frame.size
        fmScrollView.backgroundColor = UIColor.whiteColor()
        
        fmScrollView.pagingEnabled = true;
        fmScrollView.showsVerticalScrollIndicator = true;
        fmScrollView.delaysContentTouches = false;
        fmScrollView.delegate = self
        fmScrollView.addSubview(self.fmHomeView)
    }

    func doubleTapGestuer(gestureRecognizer: UITapGestureRecognizer){
        addFeeling()
    }
    
    func swipeLeftGesture(gestureRecognizer: UISwipeGestureRecognizer){
        addFeeling()
    }
    
    private func addFeeling(){
        let i = fmHomeView.getItemNumber(fmScrollView.contentOffset)
        fmModel.addFeeling(i)
        AudioServicesPlaySystemSound(seletFeelingSoundId)
        fmHomeView.doFlash(i)
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate: Bool) {
        if willDecelerate {
            AudioServicesPlaySystemSound(movePageSoundId)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // TODO: add protection to check if the destination view is really the view I want
        if segue.identifier == "showGraph" {
            let graphVc = segue.destinationViewController as! FmGraphRootViewController
            graphVc.fmModel = self.fmModel
        }
    }
 }

