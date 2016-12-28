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
        let rect = CGRect(x: 0,y: 0,width: size.width,height: size.height * CGFloat(self.numOfFeelings))
        self.itemSize = size
        super.init(frame: rect)
        self.backgroundColor = UIColor.white
        self.initItemView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initItemView()
    {
        for i in 0 ... (self.numOfFeelings - 1) {
            // add feeling color views
            let y = self.itemSize.height * CGFloat(i)
            let rect = CGRect(x: 0,y: y,width: self.itemSize.width,height: self.itemSize.height)
            let item = UIView(frame: rect)
            item.backgroundColor = dataSource.getColor(i)
            
            // add message text
            //TODO nees refactor
            let fontSize = CGFloat(30.0)
            let y2 = (rect.height / 2.0) - (fontSize / 2.0)
            let maxSize = CGSize(width: frame.width,height: frame.height)
            
            let label =  UILabel(frame: CGRect(x: 0, y: y2, width: maxSize.width, height: maxSize.height));
    
            label.text = dataSource.getText(i)
            label.textColor = item.backgroundColor
            label.backgroundColor = UIColor.white
            label.alpha = 0.8
            label.font = UIFont.systemFont(ofSize: fontSize)
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            //label.shadowColor = UIColor.blackColor()
            
            // adjust UILabel frame rect
            let labelFrameSize = CGSize(width: maxSize.width * 0.7,height: fontSize * 1.5)
            let x2 = (frame.width - labelFrameSize.width) / 2.0
            label.frame = CGRect(x: x2,y: y2,width: labelFrameSize.width , height: labelFrameSize.height)

            self.addSubview(item)
            item.addSubview(label)
            itemViewList.append(item)
        }
    }
    // retrun current item view number
    // used to check in which view, swipe gesture done.
    func getItemNumber(_ offset: CGPoint) -> Int {
        return Int(offset.y / self.itemSize.height)
    }
    
    func doFlash(_ index: Int){
        let targetView = self.itemViewList[index]
        targetView.setNeedsDisplay()    
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(),
            animations: { () -> Void in
                targetView.alpha = 0.4
            },
            completion: { (done) -> Void in
                targetView.alpha = 1.0
        })
    }
}
