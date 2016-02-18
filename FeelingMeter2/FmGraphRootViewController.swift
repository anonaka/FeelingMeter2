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
    

    @IBOutlet var fmGraphRootView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getGeometryInfo() -> FmGraphGeometryInfo {
        return FmGraphGeometryInfo()
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    override func viewWillAppear(animated: Bool) {
        setupViews()
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        setupViews()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)  {
    }
    
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
        fmGraphScrollView.bounces = false
        let rect = CGRectMake(0,0,w2,h)
        fmGraphContentView = FmGraphContentView(frame: rect, dataSource: fmModel, geometryInfo: getGeometryInfo())
        fmGraphScrollView.addSubview(fmGraphContentView)
        fmGraphRootView.addSubview(fmGraphScrollView)
    }
}
