//
//  File.swift
//  WSHitchService
//
//  Created by 七环第一帅 on 2021/7/20.
//

import UIKit

enum SurpriseShape {
    case line
    
    func layerWith(origin: CGPoint,
                   destination: CGPoint,
                   lineWidth: CGFloat = 2,
                   color: UIColor) -> CAShapeLayer {
        
        let path = UIBezierPath()
        let layer = CAShapeLayer()

        switch self {
        case .line:
            path.move(to: origin)
            path.addLine(to: destination)
            layer.lineWidth = 2.0
            layer.strokeColor = UIColor.red.cgColor
            layer.fillColor = UIColor.clear.cgColor
        }
        
        layer.path = path.cgPath
        
        return layer
    }
}
