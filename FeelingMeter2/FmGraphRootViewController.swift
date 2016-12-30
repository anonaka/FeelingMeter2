//
//  FmGraphViewController.swift
//  FeelingMeter2
//
//  Created by 野中 哲 on 2016/02/10.
//  Copyright © 2016年 TrueLogic. All rights reserved.
//

import UIKit

class FmGraphRootViewController : UIViewController
{
    struct FmGraphGeometryInfo
    {
        static let xAxisHeight = CGFloat(50.0)
        static let yAxisWidthPersentage = CGFloat(0.2)
        static let cellWidth = CGFloat(40.0)
    }
    
    var fmModel: FmModel! // set by nav controller when segue
    var fmYAxisView: FmGraphYAxisView! = nil
    var fmGraphScrollView: UIScrollView! = nil
    var fmGraphContentView: FmGraphContentView! = nil
    var needsSetupView = true
    var xScrolPos = CGFloat(0.0)
    
    @IBOutlet var fmGraphRootView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getGeometryInfo() -> FmGraphGeometryInfo {
        return FmGraphGeometryInfo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // so that animation do not run twice at init time
        if needsSetupView {
            setupViews()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        needsSetupView = false
        fmModel.gvController = self
    }
    
    override func  viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // remember scroll position
        needsSetupView = true
        xScrolPos = fmGraphScrollView.contentOffset.x / fmGraphScrollView.contentSize.width
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        needsSetupView = true
    }
    
    //debug
    /* 
    private func printScreenInfo(){
        print("frame: ",fmGraphRootView.frame)
        print("bounds: ",fmGraphRootView.bounds)
    }
    */
    
    fileprivate func setupViews(){
        fmYAxisView?.removeFromSuperview()
        fmGraphScrollView?.removeFromSuperview()
        fmGraphContentView?.removeFromSuperview()
        
        setupYAxisView()
        setupGraphView()
    }
    
    fileprivate func setupYAxisView(){
        // set up Y asxis view
 
        let x = CGFloat(0),y = CGFloat(0)
        let w = fmGraphRootView.bounds.width * FmGraphGeometryInfo.yAxisWidthPersentage
        let h = fmGraphRootView.bounds.height
        fmYAxisView = FmGraphYAxisView(frame: CGRect(x: x,y: y,width: w,height: h),dataSource: fmModel)
        fmGraphRootView.addSubview(fmYAxisView)
    }
    
    fileprivate func setupGraphView() {
        // set up graph view
        let x = fmGraphRootView.bounds.width * FmGraphGeometryInfo.yAxisWidthPersentage
        let y = CGFloat(0)
        let w = fmGraphRootView.bounds.width * (1.0 - FmGraphGeometryInfo.yAxisWidthPersentage)
        let h = fmGraphRootView.bounds.height
        self.fmGraphScrollView = UIScrollView(frame: CGRect(x: x,y: y,width: w,height: h))
        
        // calculate content size in the scroll view
        let dataCount = fmModel.getFeelingData().count
        let w2 = max(FmGraphGeometryInfo.cellWidth * CGFloat(dataCount),w)
        fmGraphScrollView.contentSize = CGSize(width: w2, height: h)
        
        // limit scroll position
        if (w2 * xScrolPos)  + fmGraphScrollView.frame.width < fmGraphScrollView.contentSize.width {
            fmGraphScrollView.contentOffset.x = w2 * xScrolPos
        } else {
            fmGraphScrollView.contentOffset.x = fmGraphScrollView.contentSize.width - fmGraphScrollView.frame.width
        }
        
        fmGraphScrollView.bounces = false
        let rect = CGRect(x: 0,y: 0,width: w2,height: h)
        fmGraphContentView = FmGraphContentView(frame: rect, dataSource: fmModel)
        fmGraphScrollView.addSubview(fmGraphContentView)
        fmGraphRootView.addSubview(fmGraphScrollView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showManagement" {
            print ("segue management view")
            // TODO: add protection to check if the destination view is really the view I want
            let vc = segue.destination as! FmManagementViewController
                vc.fmModel = self.fmModel
        }
    }
    
    func setNeedsUpdate(){
        needsSetupView = true
    }
}
