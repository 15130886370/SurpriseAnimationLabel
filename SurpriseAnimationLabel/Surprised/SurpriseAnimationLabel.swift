//
//  SurpriseAnimationLabel.swift
//  WSHitchService
//
//  Created by 七环第一帅 on 2021/7/20.
//

import UIKit

extension SurpriseAnimationLabel: CAAnimationDelegate {
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let label = animated else { return }
        if let value = anim.value(forKey: "lineAnimation") as? String, value == "lineAnimation" {
            // 划线动画结束需要把划线去掉
            label.layer.sublayers?.removeAll()
            
            guard let attribute = animationAttributed else { return }
            label.text = attribute.surpriseText
        }
        
        if let value = anim.value(forKey: "scaleAnimation") as? String, value == "scaleAnimation" {
            // 清除掉所有动画
            label.layer.removeAllAnimations()
            // 执行代理
            delegate?.animationDidStop()
        }
    }
}

/**
 支持 AutoLayout ,宽高自动撑开
 使用方法:
     
     // 1.创建若干 Attributed 用于构建 Label
     let attributed1 = Attributed(text: sharedText, font: UIFont.size(12), textColor: UIColor.text333)
     let attributed2 = AnimationAttributed(text: originPrice, font: UIFont.size(26, name: .semibold),
                                           textColor: UIColor(rgb: 0xFF4747), surpriseText: surprisePrice,
                                           lineColor: UIColor(rgb: 0xFF4747))
     let attributed3 = Attributed(text: "元", font: UIFont.size(12), textColor: UIColor.text333)
     // 2.初始化 SurpriseAnimationLabel
     let animationLabel = SurpriseAnimationLabel(
         attributeds: [attributed1, attributed2, attributed3])
     // 3.添加 Label
     ...
     --------------
     如果需要手动执行动画，可以直接 animationLabel.start()
     如果需要获取动画结束的回调，可以遵守 SurpriseAnimationLabelDelegate
*/

public protocol SurpriseAnimationLabelDelegate: class {
    func animationDidStop()
}

public final class SurpriseAnimationLabel: UIView {
    
    /// 动画效果是否正在执行,可在外部随意设置停止时机，一般情况可以在代理方法animationDidStop里面设置 false，
    /// 主要是为了防止动画加载中再次触发 start 方法，做一次拦截。
    /// ⚠️注意，如果不设置他，动画只会执行一次!!
    public var animationLoading: Bool = false
    /// 动画是否加载过(要区分开 animationLoading, animationLoaded是第一次加载了动画)
    /// 用于防止 layoutSubviews 多次执行动画
    public var animationLoaded: Bool = false
    /// 生成的 UILabel 数组
    public var labels: [UILabel] = []
    /// 做动画的 Label，外界可以直接使用，如果想要使用其他的Label
    /// 可以直接从 labels 下标取
    public var animated: UILabel?
    /// 外界传进来一组字符串，用于创建一组 UILabel
    private let attributeds: [SurpriseAttributed]
    /// 需要告知 SurpriseAnimationLabel 第几个 Label 做动画
    private var animationIndex: Int?
    /// 需要做动画的 Label 字体是否比其它的大，默认 true
    private let animationLabelIsLarge: Bool
    /// 缩放动画结束后，是否播放爆炸效果
    private let isPlaySpark: Bool
    /// 动画 Attributed, 可以随着 start 方法改变
    private var animationAttributed: AnimationAttributed?
    /// 设置代理
    public weak var delegate: SurpriseAnimationLabelDelegate?
    
    /**
     ⚠️~~~！attributeds 数组必须包含一个 SurpriseAnimationAttributed 用于动画
     并且~~！animationIndex 必须与 SurpriseAnimationAttributed 的位置对应
     否则~~！得不到正确的动画
     另外~~!  isPlaySpark 理论上不应该与 SurpriseAnimationLabel 关联，这只是
     在顺风车上的一个火花效果，所以默认不显示
     */
    public init(attributeds: [SurpriseAttributed],
         animationLabelIsLarge: Bool = true,
         frame: CGRect = .zero) {
    
        self.isPlaySpark = true
        self.attributeds = attributeds
        self.animationLabelIsLarge = animationLabelIsLarge
        
        super.init(frame: frame)
        
        /**
         ⚠️~！如果 attributeds 没有一个 SurpriseAnimationAttributed，将无法执行动画 ~！⚠️
         */
        guard let index = attributeds.firstIndex(
                where: { $0 is SurpriseAnimationAttributed }) else { return }
        
        self.animationIndex = index
        self.animationAttributed = attributeds[index] as? AnimationAttributed
        
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()

        if self.frame.size.width != 0 {

            guard !animationLoaded,
                  let attributed = animationAttributed else { return }
            self.start(
                origin: attributed.text,
                surprisedText: attributed.surpriseText)
        }
    }
    
    /// 开启动画，外界可重复调用
    public func start(origin text: String? = nil, surprisedText: String? = nil) {
        
        guard !animationLoading else { return }
        
        guard let index = animationIndex,
              let label = labels.safe[index],
              let attribute = attributeds.safe[index] as? SurpriseAnimationAttributed
        else {
            let description =
            """
            ❌
            1.传入的 attributeds 没有 SurpriseAnimationAttributed
            2.做动画的 attribute 必须要有划线颜色, 和划线宽度(默认是2)
            """
            ws_print("\(description)")
            return
        }
        
        if let surpresed = surprisedText {
            animationAttributed?.surpriseText = surpresed
        }
        animated?.text = text
        
        let width = label.frame.maxX - label.frame.minX
        let origin = CGPoint(x: -3.0, y: label.center.y)
        let destination = CGPoint(x: width + 6.0, y: label.center.y)
        
        animationLoading = true
        SurpriseAnimation.setupAnimation(
            with: label.layer,
            duration: 0.35,
            origin: origin,
            destination: destination,
            lineWidth: attribute.lineWidth,
            color: attribute.lineColor,
            delegate: self)
        
        animationLoaded = true
    }
    
    private func setupUI() {
        backgroundColor = UIColor.clear
        setupLabels()
    }
    
    private func setupLabels() {
        var tempLabels: [UILabel] = []
        
        var preLabel: UILabel?
        attributeds.enumerated().forEach { [weak self] index, attributed in
            
            guard let `self` = self else { return }
            let label = UILabel()
            label.text = attributed.text
            label.font = attributed.font
            label.textColor = attributed.textColor
            tempLabels.append(label)
            // 这里已经添加上了
            self.addSubview(label)
            // 开始布局
            label.translatesAutoresizingMaskIntoConstraints = false
            if let pre = preLabel {
                // 有上一个 Label
                label.leftAnchor.constraint(equalTo: pre.rightAnchor, constant: 5).isActive = true
                label.firstBaselineAnchor.constraint(equalTo: pre.firstBaselineAnchor).isActive = true
            } else {
                label.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
                label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            }
            // 最后一个 Label
            if index == attributeds.count - 1 {
                label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
            }
            
            // 循环到当前动画 label，并且动画label是比其它的 labe 字体大的
            if animationLabelIsLarge && index == animationIndex {
                label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            }
            // ⚠️ 动画 label 如果字体比其它的小，那就要根据其它 label
            // 设置相对父视图的顶部约束，以确保父视图的高度撑开(⚠️强烈不建议这么搞)
            if !animationLabelIsLarge && index != animationIndex {
                label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            }
            
            preLabel = label
        }
        
        labels = tempLabels
        
        guard let index = animationIndex else {
            
            ws_print("❌❌❌")
            return
        }
        animated = tempLabels.safe[index]
    }
    
}

public func ws_print<T>(_ message: T, file: String = #file, method: String = #function, line: Int = #line) {
    debugPrint("💋 \((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
}

