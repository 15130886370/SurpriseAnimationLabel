//
//  ViewController.swift
//  SurpriseAnimationLabel
//
//  Created by 七环第一帅 on 2021/7/29.
//

import UIKit

extension ViewController: SurpriseAnimationLabelDelegate {
    func animationDidStop() {
        // 动画结束，播放火花
        guard let label = animationLabel?.animated else { return }
        fireworkController.addFireworks(count: 2, sparks: 8, around: label)
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attributed1 = Attributed(text: "惊爆价", font: UIFont.systemFont(ofSize: 12), textColor: UIColor.gray)
        let attributed2 = AnimationAttributed(text: "120", font: UIFont.systemFont(ofSize: 26, weight: .semibold),
                                              textColor: UIColor.red, surpriseText: "100",
                                              lineColor: UIColor.red)
        let attributed3 = Attributed(text: "元", font: UIFont.systemFont(ofSize: 12), textColor: UIColor.gray)
    
        let animationLabel = SurpriseAnimationLabel(
            attributeds: [attributed1, attributed2, attributed3])
        view.addSubview(animationLabel)
        animationLabel.delegate = self
        animationLabel.translatesAutoresizingMaskIntoConstraints = false
        animationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        animationLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        self.animationLabel = animationLabel
        
        addButton()
        
        // 一定要找一个时机把 animationLoading 设为 false，否则
        // 动画只会执行第一次。这里就在火花动画结束后设置。
        fireworkController.animationCompleted = { [weak self] in
            self?.animationLabel?.animationLoading = false
        }
    }
    
    private func addButton() {
        view.addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.topAnchor.constraint(equalTo: animationLabel!.bottomAnchor, constant: 50).isActive = true
    }


    
    @objc func startAnimation() {
        animationLabel?.start(origin: "120", surprisedText: "100")
    }
    private var animationLabel: SurpriseAnimationLabel?
    
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("开始", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(startAnimation), for: .touchUpInside)
        
        return button
    }()
    
    private let fireworkController = ClassicFireworkController()
}

