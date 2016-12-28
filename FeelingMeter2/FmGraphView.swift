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
  
    func getText(_ i: Int) -> String {
        return "hoge"
    }
    
    func getColor(_ i: Int) -> UIColor{
        return UIColor.gray
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
    let dataSource: FmGraphDataSource
    
    init(frame: CGRect, dataSource: FmGraphDataSource){
        self.dataSource = dataSource
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView(){
        let numOfFeelings = dataSource.getNumOfFeelings()
        let cellHeight = (frame.height - FmGraphRootViewController.FmGraphGeometryInfo.xAxisHeight) / CGFloat(numOfFeelings)
        
        for i in 0 ..< numOfFeelings {
            let x = CGFloat(0)
            let y = CGFloat(i) * cellHeight
            let w = frame.width
            let h = cellHeight
            
            let v = UIView(frame: CGRect(x: x,y: y,width: w,height: h))
            v.backgroundColor = dataSource.getColor(i)
            drawColorLableInView(v, x: x, y: y, index: i)
            self.addSubview(v)
        }
    }
    
    fileprivate func drawColorLableInView(_ view: UIView,x:CGFloat ,y:CGFloat, index: Int){
        let widthRatio = CGFloat(0.9)
        let text = dataSource.getText(index)
        let fontSize = CGFloat(10)
        let x2 = (view.bounds.width * (1 - widthRatio)) / 2.0
        let label = UILabel(frame: CGRect(x: x2,y: view.bounds.midY - (fontSize / 2.0), width: view.bounds.width * widthRatio, height: 12.0))
        label.alpha = 0.9
        label.text = text
        label.textColor = dataSource.getColor(index)
        label.backgroundColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        view.addSubview(label)
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
    let graphColor = UIColor.gray.cgColor
    let duration = 0.8

    init(frame: CGRect, dataSource: FmGraphDataSource){
        fmGraphDataSource = dataSource
        //fmGraphDataSource = TestDataSource() // fro debugging
        data = fmGraphDataSource.getFeelingData()
        dataCount = data.count
        numOfFeelings = fmGraphDataSource.getNumOfFeelings()
        xAxisHeight =  FmGraphRootViewController.FmGraphGeometryInfo.xAxisHeight
        cellHeight = (frame.height - xAxisHeight) / CGFloat(numOfFeelings)
        cellWidth = FmGraphRootViewController.FmGraphGeometryInfo.cellWidth
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        drawAllGraphPointsAdnLines()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func draw(_ rect: CGRect) {
        drawXAxis()
        drawHolizontalLines()
    }
    
    fileprivate func drawAllGraphPointsAdnLines(){
        var oldPoint:CGPoint!
        for i in 0 ..< dataCount {
            let aFeeling = data[i]
            let x = CGFloat(i) * cellWidth + (cellWidth / 2.0)
            let y = CGFloat(aFeeling.feeling) * cellHeight + (cellHeight / 2.0)
            let newPoint = CGPoint(x: x, y: y)
            drawGraphPoint(newPoint)
            if oldPoint != nil {
                drawGraphLinesFrom(oldPoint, p2: newPoint,color: UIColor.gray,width: 5, doAimation: true)
            }
            oldPoint = newPoint
        }
    }
    
    fileprivate func drawHolizontalLines(){
        for i in 1 ... numOfFeelings {
            let x1 = CGFloat(0.0)
            let x2 = frame.width
            let y1 = CGFloat(i) * cellHeight
            let p1 = CGPoint(x: x1,y: y1)
            let p2 = CGPoint(x: x2,y: y1)
            drawGraphLinesFrom(p1,p2: p2)
        }
    }
    
    fileprivate func drawXAxis(){
        let y = self.frame.height - xAxisHeight
        for i in 0 ..< dataCount {
            let x = CGFloat(i) * cellWidth
            let text = dateString(data[i].date as Date)
            let rect = CGRect(x: x, y: y,width: cellWidth, height: xAxisHeight)
            drawTextAt(rect, text: text)
        }
    }
    
    fileprivate func dateString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
//        dateFormatter.timeStyle = .NoStyle
//        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.dateFormat = "MM/dd"
        let dateString: String = dateFormatter.string(from: date)
        
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        let timeString: String = dateFormatter.string(from: date)
        
        let cal: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let comp: DateComponents = (cal as NSCalendar).components(
            [NSCalendar.Unit.weekday],
            from: date
        )
        let weekdaySymbolIndex: Int = comp.weekday! - 1
        let weekDayStr = dateFormatter.shortWeekdaySymbols[weekdaySymbolIndex]
        
        return dateString + "\n" + weekDayStr + "\n" +  timeString
    }
    
    fileprivate func drawTextAt(_ frame: CGRect ,text: String){
        let label = UILabel(frame: frame)
        label.text = text
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 3
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 11.0)
        self.addSubview(label)
    }
    
    
    fileprivate func drawGraphPoint(_ center: CGPoint){
        let radius = CGFloat(10.0)
        let myLayer = CAShapeLayer()
        self.layer.addSublayer(myLayer)

        let endCircle = UIBezierPath(arcCenter: center,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2.0) * CGFloat(M_PI),
            clockwise: true)
 
        let startY = self.frame.height - xAxisHeight
        let startCircle = UIBezierPath(arcCenter: CGPoint(x: center.x,y: startY),
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2.0) * CGFloat(M_PI),
            clockwise: true)

        myLayer.path = startCircle.cgPath
        myLayer.lineWidth = 2
        myLayer.strokeColor = graphColor
        myLayer.fillColor = graphColor
        
        // TODO: more refactor animation
        let animation = CABasicAnimation(keyPath: "path")
        
        animation.duration = duration
        animation.fromValue = myLayer.path
        animation.toValue = endCircle.cgPath
        
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut) // animation curve is Ease Out
        animation.fillMode = kCAFillModeBoth // keep to value after finishing
        animation.isRemovedOnCompletion = false // don't remove after finishing
        
        myLayer.add(animation, forKey: animation.keyPath)
    }
    
    fileprivate func drawGraphLinesFrom(_ p1:CGPoint,p2:CGPoint,color:UIColor = UIColor.black ,
            width: CGFloat = 1,
            doAimation: Bool = false)
    {
        let startY = self.frame.height - xAxisHeight
        let myLayer = CAShapeLayer()
        self.layer.addSublayer(myLayer)
       
        let endLine = UIBezierPath();
        endLine.move(to: p1);
        endLine.addLine(to: p2);
        
        let startLine = UIBezierPath();
        startLine.move(to: CGPoint(x: p1.x, y: startY))
        startLine.addLine(to: CGPoint(x: p2.x, y: startY))

        myLayer.lineWidth = width
        myLayer.strokeColor = graphColor
        myLayer.fillColor = graphColor
        // TODO: more refactor animation
        if doAimation {
            myLayer.path = startLine.cgPath
            let animation = CABasicAnimation(keyPath: "path")
        
            animation.duration = duration
            animation.fromValue = myLayer.path
            animation.toValue = endLine.cgPath
            
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut) // animation curve is Ease Out
            animation.fillMode = kCAFillModeBoth // keep to value after finishing
            animation.isRemovedOnCompletion = false // don't remove after finishing
            myLayer.add(animation, forKey: animation.keyPath)
         
        } else {
            myLayer.path = endLine.cgPath
        }
    }
}


