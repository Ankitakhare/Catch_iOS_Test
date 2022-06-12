
//
//  CircularProgressBarView.swift
//  Catch_AssignmentTest
//
//  Created by ankita khare on 12/06/22.
//

import UIKit
 
class CircularProgressBarView : UIView{
   
    // Properties
    
        private var circleLayer = CAShapeLayer()
        private var progressLayer = CAShapeLayer()
        private var startPoint = CGFloat(-Double.pi / 2)
        private var endPoint = CGFloat(3 * Double.pi / 2)
    private var _currentProgress:CGFloat = 0.0
    var currentProgress:CGFloat{
        set{
            _currentProgress = newValue
            progressAnimation(duration: 1.0, value: newValue)
        }
        get{
            return _currentProgress
        }
    }
       
        override init(frame: CGRect) {
            super.init(frame: frame)
            createCircularPath()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            createCircularPath()
        }
    
        func createCircularPath() {
            // created circularPath for circleLayer and progressLayer
            let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 20, startAngle: startPoint, endAngle: endPoint, clockwise: true)
            // circleLayer path defined to circularPath
            circleLayer.path = circularPath.cgPath
            // ui edits
            circleLayer.fillColor = UIColor.clear.cgColor
            circleLayer.lineCap = .round
            circleLayer.lineWidth = 5.0
            circleLayer.strokeEnd = 1.0
            circleLayer.strokeColor = UIColor.white.cgColor
            // added circleLayer to layer
            layer.addSublayer(circleLayer)
            // progressLayer path defined to circularPath
            progressLayer.path = circularPath.cgPath
            // ui edits
            progressLayer.fillColor = UIColor.clear.cgColor
            progressLayer.lineCap = .round
            progressLayer.lineWidth = 5.0
            progressLayer.strokeEnd = 0
            progressLayer.strokeColor = UIColor.red.cgColor
            // added progressLayer to layer
            layer.addSublayer(progressLayer)
        }
    
    func progressAnimation(duration: TimeInterval, value: CGFloat) {
            // created circularProgressAnimation with keyPath
            let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
            // set the end time
            circularProgressAnimation.duration = duration
            circularProgressAnimation.toValue = value
            circularProgressAnimation.fillMode = .forwards
            circularProgressAnimation.isRemovedOnCompletion = false
            progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
        }
    
}
