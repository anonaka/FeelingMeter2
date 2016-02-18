//
//  FmGraphView.swift
//  FeelingMeter2
//
//  Created by 野中 哲 on 2016/02/10.
//  Copyright © 2016年 TrueLogic. All rights reserved.
//

import UIKit

class TestDataSource: FmGraphDataSource {
    let model = FmModel()
    
    func getNumOfFeelings() -> Int {
        return 5
    }
    
    func getFeelingData() -> [FmModel.FeelingItem]{
        return model.feelings
    }
  
    func getText(i: Int) -> String {
        return "hoge"
    }
    
    func getColor(i: Int) -> UIColor{
        return UIColor.grayColor()
    }
    
    init()
    {
        for _ in 0 ..< 30 {
            let n = Int(arc4random()) % getNumOfFeelings();
            model.addFeeling(n)
        }
    }
}



class FmGraphYAxisView: UIView {
    let ginfo: FmGraphRootViewController.FmGraphGeometryInfo
    let dataSource: FmGraphDataSource
    
    init(frame: CGRect, dataSource: FmGraphDataSource, geometryInfo: FmGraphRootViewController.FmGraphGeometryInfo){
        ginfo = geometryInfo
        self.dataSource = dataSource
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        let numOfFeelings = dataSource.getNumOfFeelings()
        let cellHeight = (frame.height - ginfo.xAxisHeight) / CGFloat(numOfFeelings)
        
        for i in 0 ..< numOfFeelings {
            let x = CGFloat(0)
            let y = CGFloat(i) * cellHeight
            let w = frame.width
            let h = cellHeight
            
            let v = UIView(frame: CGRectMake(x,y,w,h))
            v.backgroundColor = dataSource.getColor(i)
            self.addSubview(v)
        }
    }
}


class FmGraphContentView : UIView {
    let fmGraphDataSource: FmGraphDataSource!
    let dataCount: Int
    let data: [FmModel.FeelingItem]
    let numOfFeelings: Int

    let cellHeight: CGFloat
    let xAxisHeight: CGFloat
    let cellWidth: CGFloat

    init(frame: CGRect, dataSource: FmGraphDataSource, geometryInfo: FmGraphRootViewController.FmGraphGeometryInfo){
        fmGraphDataSource = dataSource
        //fmGraphDataSource = TestDataSource() // fro debugging
        data = fmGraphDataSource.getFeelingData()
        dataCount = data.count
        numOfFeelings = fmGraphDataSource.getNumOfFeelings()
        xAxisHeight =  geometryInfo.xAxisHeight
        cellHeight = (frame.height - xAxisHeight) / CGFloat(numOfFeelings)
        cellWidth = geometryInfo.cellWidth
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        drawAllGraphPointsAdnLines()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func drawRect(rect: CGRect) {
        drawXAxis()
        drawHolizontalLines()
    }
    
    private func drawAllGraphPointsAdnLines(){
        var oldPoint:CGPoint!
        for i in 0 ..< dataCount {
            let aFeeling = data[i]
            let x = CGFloat(i) * cellWidth + (cellWidth / 2.0)
            let y = CGFloat(aFeeling.feeling) * cellHeight + (cellHeight / 2.0)
            let newPoint = CGPointMake(x, y)
            drawGraphPoint(newPoint)
            if oldPoint != nil {
                drawGraphLinesFrom(oldPoint, p2: newPoint,color: UIColor.grayColor(),width: 5)
            }
            oldPoint = newPoint
        }
    }
    
    private func drawHolizontalLines(){
        for i in 1 ... numOfFeelings {
            let x1 = CGFloat(0.0)
            let x2 = frame.width
            let y1 = CGFloat(i) * cellHeight
            let p1 = CGPointMake(x1,y1)
            let p2 = CGPointMake(x2,y1)
            drawGraphLinesFrom(p1,p2: p2)
        }
    }
    
    private func drawXAxis(){
        let y = self.frame.height - xAxisHeight
        for i in 0 ..< dataCount {
            let x = CGFloat(i) * cellWidth
            let text = dateString(data[i].date)
            drawTextAt(CGPointMake(x, y),text: text)
        }
    }
    
    private func dateString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd\nHH:mm:ss"
        let dateString: String = dateFormatter.stringFromDate(date)
        return dateString
    }
    
    private func drawTextAt(point: CGPoint,text: String){
        // フォント属性
        let fontAttr = [NSFontAttributeName: UIFont.systemFontOfSize(12)]
        // テキスト
        let str = text as NSString!
        // テキスト描画
        str.drawAtPoint(point, withAttributes: fontAttr)
    }
    
    private func drawGraphPoint(center: CGPoint){
        let radius = CGFloat(10.0)
        let myLayer = CAShapeLayer()
        self.layer.addSublayer(myLayer)

        let endCircle = UIBezierPath(arcCenter: center,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2.0) * CGFloat(M_PI),
            clockwise: true)
 
        let startY = self.frame.height - xAxisHeight
        let startCircle = UIBezierPath(arcCenter: CGPointMake(center.x,startY),
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2.0) * CGFloat(M_PI),
            clockwise: true)

        myLayer.path = startCircle.CGPath
        myLayer.lineWidth = 2
        myLayer.strokeColor = UIColor.redColor().CGColor
        myLayer.fillColor = UIColor.redColor().CGColor
        let animation = CABasicAnimation(keyPath: "path")
        
        animation.duration = 1.0
        animation.fromValue = myLayer.path
        animation.toValue = endCircle.CGPath
        
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut) // animation curve is Ease Out
        animation.fillMode = kCAFillModeBoth // keep to value after finishing
        animation.removedOnCompletion = false // don't remove after finishing
        
        myLayer.addAnimation(animation, forKey: animation.keyPath)
    }
    
    private func drawGraphLinesFrom(p1:CGPoint,p2:CGPoint,color:UIColor = UIColor.blackColor() ,width: CGFloat = 1){
        let myLayer = CAShapeLayer()
        self.layer.addSublayer(myLayer)
       
        let endLine = UIBezierPath();
        endLine.moveToPoint(p1);
        endLine.addLineToPoint(p2);
        
        let startLine = UIBezierPath();
        startLine.moveToPoint(CGPointMake(p1.x, CGFloat(0)))
        startLine.addLineToPoint(CGPointMake(p2.x, CGFloat(0)))

        myLayer.path = startLine.CGPath
        myLayer.lineWidth = 2
        myLayer.strokeColor = UIColor.redColor().CGColor
        myLayer.fillColor = UIColor.redColor().CGColor
        
        let animation = CABasicAnimation(keyPath: "path")
        
        animation.duration = 1.0
        animation.fromValue = myLayer.path
        animation.toValue = endLine.CGPath
        
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut) // animation curve is Ease Out
        animation.fillMode = kCAFillModeBoth // keep to value after finishing
        animation.removedOnCompletion = false // don't remove after finishing
        
        myLayer.addAnimation(animation, forKey: animation.keyPath)
    }
}


