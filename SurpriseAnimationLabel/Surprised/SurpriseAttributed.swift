//
//  SurpriseAttributed.swift
//  WSHitchService
//
//  Created by 七环第一帅 on 2021/7/20.
//

import UIKit

public protocol SurpriseAttributed {
    var text: String { get }
    var font: UIFont { get }
    var textColor: UIColor { get }
}

public protocol SurpriseAnimationAttributed: SurpriseAttributed {
    var surpriseText: String { get }
    var lineColor: UIColor { get }
    var lineWidth: CGFloat { get }
}

/// 动画 Label 需要用到的属性，需要制定划线宽度，颜色
public struct AnimationAttributed: SurpriseAnimationAttributed {
    public var text: String
    public let font: UIFont
    public let textColor: UIColor
    public var surpriseText: String
    public let lineColor: UIColor
    public let lineWidth: CGFloat
    
    public init(text: String, font: UIFont, textColor: UIColor, surpriseText: String, lineColor: UIColor, lineWidth: CGFloat = 2.0) {
        self.text = text
        self.font = font
        self.textColor = textColor
        self.surpriseText = surpriseText
        self.lineColor = lineColor
        self.lineWidth = lineWidth
    }
}

/// 普通 Label 需要用到的属性]
public struct Attributed: SurpriseAttributed {
    public let text: String
    public let font: UIFont
    public let textColor: UIColor
    
    public init(text: String, font: UIFont, textColor: UIColor) {
        self.text = text
        self.font = font
        self.textColor = textColor
    }
}
