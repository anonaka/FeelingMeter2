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
        let xAxisHeight = CGFloat(50.0)
        let yAxisWidthPersentage = CGFloat(0.2)
        let cellWidth = CGFloat(80.0)
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        needsSetupView = false
        fmModel.gvController = self
    }
    
    override func  viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        // remember scroll position
        xScrolPos = fmGraphScrollView.contentOffset.x / fmGraphScrollView.contentSize.width
    }

    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        needsSetupView = true
    }
    
    //debug
    /* 
    private func printScreenInfo(){
        print("frame: ",fmGraphRootView.frame)
        print("bounds: ",fmGraphRootView.bounds)
    }
    */
    
    private func setupViews(){
        fmYAxisView?.removeFromSuperview()
        fmGraphScrollView?.removeFromSuperview()
        fmGraphContentView?.removeFromSuperview()
        
        setupYAxisView()
        setupGraphView()
    }
    
    private func setupYAxisView(){
        // set up Y asxis view
 
        let x = CGFloat(0),y = CGFloat(0)
        let w = fmGraphRootView.bounds.width * getGeometryInfo().yAxisWidthPersentage
        let h = fmGraphRootView.bounds.height
        fmYAxisView = FmGraphYAxisView(frame: CGRectMake(x,y,w,h),dataSource: fmModel, geometryInfo: getGeometryInfo())
        fmGraphRootView.addSubview(fmYAxisView)
    }
    
    private func setupGraphView() {
        // set up graph view
        let x = fmGraphRootView.bounds.width * getGeometryInfo().yAxisWidthPersentage
        let y = CGFloat(0)
        let w = fmGraphRootView.bounds.width * (1.0 - getGeometryInfo().yAxisWidthPersentage)
        let h = fmGraphRootView.bounds.height
        self.fmGraphScrollView = UIScrollView(frame: CGRectMake(x,y,w,h))
        
        // calculate content size in the scroll view
        let cellWidth = CGFloat(80.0)
        let dataCount = fmModel.getFeelingData().count
        let w2 = max(cellWidth * CGFloat(dataCount),w)
        fmGraphScrollView.contentSize = CGSizeMake(w2, h)
        
        // limit scroll position
        if (w2 * xScrolPos)  + fmGraphScrollView.frame.width < fmGraphScrollView.contentSize.width {
            fmGraphScrollView.contentOffset.x = w2 * xScrolPos
        } else {
            fmGraphScrollView.contentOffset.x = fmGraphScrollView.contentSize.width - fmGraphScrollView.frame.width
        }
        
        fmGraphScrollView.bounces = false
        let rect = CGRectMake(0,0,w2,h)
        fmGraphContentView = FmGraphContentView(frame: rect, dataSource: fmModel, geometryInfo: getGeometryInfo())
        fmGraphScrollView.addSubview(fmGraphContentView)
        fmGraphRootView.addSubview(fmGraphScrollView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showManagement" {
            print ("segue management view")
            // TODO: add protection to check if the destination view is really the view I want
            let vc = segue.destinationViewController as! FmManagementViewController
                vc.fmModel = self.fmModel
        }
    }
    
    func setNeedsUpdate(){
        needsSetupView = true
    }
}
