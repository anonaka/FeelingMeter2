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
    
    var currentFeelingNumber = 0
    
    override func viewWillLayoutSubviews() {
        self.setupViews()
    }
    
    fileprivate func setupViews(){
        self.view.backgroundColor = UIColor.white
        
        // TODO: setup sound must be done in the app init time
        
        let seletFeelingSoundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "coin4", ofType: "mp3")!)
        AudioServicesCreateSystemSoundID(seletFeelingSoundURL as CFURL, &seletFeelingSoundId)
 
        let movePageSoundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "jump2", ofType: "mp3")!)
        AudioServicesCreateSystemSoundID(movePageSoundURL as CFURL, &movePageSoundId)
       
        let size = CGSize(
            width: self.view.frame.size.width,
            height: self.view.frame.size.height - self.topLayoutGuide.length);
  
        if let v = self.fmHomeView
            { v.removeFromSuperview() }
        
        self.fmHomeView = FmHomeView(size: size, dataSource: fmModel)
        let gr = UISwipeGestureRecognizer(target: self, action: #selector(FmHomeViewController.swipeLeftGesture(_:)))
        gr.direction = UISwipeGestureRecognizerDirection.left
        self.fmHomeView.addGestureRecognizer(gr)
        
        // add doub tap gesgure
        let gr2 = UITapGestureRecognizer(target: self, action: #selector(FmHomeViewController.doubleTapGestuer(_:)))
        gr2.numberOfTapsRequired = 2
        self.fmHomeView.addGestureRecognizer(gr2)
        
        fmScrollView.contentSize = fmHomeView.frame.size
        fmScrollView.contentOffset.y = fmScrollView.frame.size.height * CGFloat(currentFeelingNumber)
        fmScrollView.backgroundColor = UIColor.white
        fmScrollView.isPagingEnabled = true;
        fmScrollView.showsVerticalScrollIndicator = true;
        fmScrollView.delaysContentTouches = false;
        fmScrollView.delegate = self
        fmScrollView.addSubview(self.fmHomeView)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        currentFeelingNumber = fmHomeView.getItemNumber(fmScrollView.contentOffset)
    }
    
    
    func doubleTapGestuer(_ gestureRecognizer: UITapGestureRecognizer){
        addFeeling()
    }
    
    func swipeLeftGesture(_ gestureRecognizer: UISwipeGestureRecognizer){
        addFeeling()
    }
    
    fileprivate func addFeeling(){
        let i = fmHomeView.getItemNumber(fmScrollView.contentOffset)
        fmModel.addFeeling(i)
        AudioServicesPlaySystemSound(seletFeelingSoundId)
        fmHomeView.doFlash(i)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate: Bool) {
        if willDecelerate {
            AudioServicesPlaySystemSound(movePageSoundId)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TODO: add protection to check if the destination view is really the view I want
        if segue.identifier == "showGraph" {
            let graphVc = segue.destination as! FmGraphRootViewController
            graphVc.fmModel = self.fmModel
        }
    }
 }

