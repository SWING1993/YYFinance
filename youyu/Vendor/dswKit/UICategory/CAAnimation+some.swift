//
//  animationSome.swift
//  qtyd
//
//  Created by stephendsw on 16/6/16.
//  Copyright © 2016年 qtyd. All rights reserved.
//

import Foundation
import UIKit


extension CAAnimation
{
   static func shake() -> CAAnimation {
       
        let popAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
        popAnimation.duration = 0.4
        popAnimation.values = [NSValue(caTransform3D: CATransform3DMakeScale(0.01, 0.01, 1.0)), NSValue(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)), NSValue(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)), NSValue(caTransform3D: CATransform3DIdentity)]
        popAnimation.keyTimes = [0.0, 0.5, 0.75, 1.0]
        popAnimation.timingFunctions = [CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut),
                                        CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)]

        return popAnimation
        
        
    }
}

