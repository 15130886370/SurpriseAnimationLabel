//
//  SurpriseAnimation.swift
//  WSHitchService
//
//  Created by 七环第一帅 on 2021/7/20.
//

import UIKit

struct SurpriseAnimation {
    
    
    /// 两段动画，划线，缩放
    /// - Parameters:
    ///   - layer: 动画 View 的 Layer
    ///   - duration: 划线动画时长
    ///   - origin: 划线的原点
    ///   - destination: 划线的终点
    ///   - lineWidth: 线宽
    ///   - color: 线条颜色
    static func setupAnimation(with layer: CALayer,
                               duration: CFTimeInterval,
                               origin: CGPoint,
                               destination: CGPoint,
                               lineWidth: CGFloat?,
                               color: UIColor,
                               delegate: CAAnimationDelegate?) {
        
        let lineAnimation = CABasicAnimation(keyPath: "strokeEnd")
        let beginTime = CACurrentMediaTime()
        
        lineAnimation.fromValue = 0
        lineAnimation.toValue = 1
        lineAnimation.duration = duration
        lineAnimation.beginTime = beginTime
        lineAnimation.delegate = delegate
        lineAnimation.setValue("lineAnimation", forKey: "lineAnimation")
        
        let lineLayer = SurpriseShape.line.layerWith(
            origin: origin,
            destination: destination,
            lineWidth: lineWidth ?? 2,
            color: color)
        
        lineLayer.add(lineAnimation, forKey: "lineAnimation")
        layer.addSublayer(lineLayer)
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 0.15
        scaleAnimation.fromValue = 0.9
        scaleAnimation.toValue = 1.2
        scaleAnimation.isRemovedOnCompletion = true
        scaleAnimation.repeatCount = 1
        scaleAnimation.beginTime = beginTime + duration
        scaleAnimation.delegate = delegate
        scaleAnimation.setValue("scaleAnimation", forKey: "scaleAnimation")
        
        layer.add(scaleAnimation, forKey: "scaleAnimation")
    }
}
