//
//  FmTouchView.swift
//  FeelingMeter2
//
//  Created by 野中 哲 on 2016/02/04.
//  Copyright © 2016年 TrueLogic. All rights reserved.
//

import UIKit

class FmHomeView : UIView {
    let itemSize: CGSize
    let numOfFeelings: Int
    let dataSource: FmGraphDataSource
    var itemViewList = [UIView]()
    
    // 端末の画面サイズをもらい、そのFeeling数分だけ縦に拡張したフレームで初期化する
    init(size: CGSize, dataSource: FmGraphDataSource)
    {
        self.dataSource = dataSource
        self.numOfFeelings = dataSource.getNumOfFeelings()
        let rect = CGRectMake(0,0,size.width,size.height * CGFloat(self.numOfFeelings))
        self.itemSize = size
        super.init(frame: rect)
        self.backgroundColor = UIColor.whiteColor()
        self.initItemView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initItemView()
    {
        for i in 0 ... (self.numOfFeelings - 1) {
            // add feeling color views
            let y = self.itemSize.height * CGFloat(i)
            let rect = CGRectMake(0,y,self.itemSize.width,self.itemSize.height)
            let item = UIView(frame: rect)
            item.backgroundColor = dataSource.getColor(i)
            
            // add message text
            //TODO nees refactor
            let fontSize = CGFloat(30.0)
            let y2 = (rect.height / 2.0) - (fontSize / 2.0)
            let maxSize = CGSizeMake(frame.width,frame.height)
            
            let label =  UILabel(frame: CGRectMake(0, y2, maxSize.width, maxSize.height));
    
            label.text = dataSource.getText(i)
            label.textColor = item.backgroundColor
            label.backgroundColor = UIColor.whiteColor()
            label.alpha = 0.8
            label.font = UIFont.systemFontOfSize(fontSize)
            label.textAlignment = .Center
            label.adjustsFontSizeToFitWidth = true
            //label.shadowColor = UIColor.blackColor()
            
            // adjust UILabel frame rect
            let labelFrameSize = CGSizeMake(maxSize.width * 0.7,fontSize * 1.5)
            let x2 = (frame.width - labelFrameSize.width) / 2.0
            label.frame = CGRectMake(x2,y2,labelFrameSize.width , labelFrameSize.height)

            self.addSubview(item)
            item.addSubview(label)
            itemViewList.append(item)
        }
    }
    // retrun current item view number
    // used to check in which view, swipe gesture done.
    func getItemNumber(offset: CGPoint) -> Int {
        return Int(offset.y / self.itemSize.height)
    }
    
    func doFlash(index: Int){
        let targetView = self.itemViewList[index]
        targetView.setNeedsDisplay()    
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { () -> Void in
                targetView.alpha = 0.4
            },
            completion: { (done) -> Void in
                targetView.alpha = 1.0
        })
    }
}
