//
//  ShakeViewAnimation.swift
//  ChatApp
//
//  Created by Roman Khodukin on 29.04.2021.
//

import UIKit

protocol IViewAnimation {
    func start()
    func stop()
}

class ShakeViewAnimation: IViewAnimation {
    
    // MARK: - Private properties
    
    private let view: UIView?
    private var isShaking: Bool = false
    private let offset: CGFloat = -5
    private let duration = 0.3
    
    // MARK: - Init
    
    init(view: UIView?) {
        self.view = view
    }
    
    // MARK: - Public Methods
    
    func start() {
        guard let view = view else { return }

        view.layer.removeAnimation(forKey: "StopShacking")
        let positionXAnimation = CAKeyframeAnimation()
        positionXAnimation.keyPath = "position.x"
        positionXAnimation.values = [view.center.x,
                                     view.center.x + offset,
                                     view.center.x,
                                     view.center.x - offset,
                                     view.center.x]
        positionXAnimation.keyTimes = [0, 0.25, 0.5, 0.75, 1]
        
        let positionYAnimation = CAKeyframeAnimation()
        positionYAnimation.keyPath = "position.y"
        positionYAnimation.values = [view.center.y,
                                     view.center.y + offset,
                                     view.center.y,
                                     view.center.y - offset,
                                     view.center.y]
        positionYAnimation.keyTimes = [0, 0.25, 0.5, 0.75, 1]

        let rotateAnimation = CAKeyframeAnimation()
        rotateAnimation.keyPath = "transform.rotation"
        rotateAnimation.values = [0, -Double.pi / 10, 0, Double.pi / 10, 0]
        rotateAnimation.keyTimes = [0, 0.25, 0.5, 0.75, 1]
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = .infinity
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [positionXAnimation, positionYAnimation, rotateAnimation]
        animationGroup.duration = duration
        animationGroup.repeatCount = .infinity
        view.layer.add(animationGroup, forKey: "Shaking")
    }
    
    func stop() {
        guard let layer = view?.layer.presentation(),
              let view = view else { return }
        layer.removeAnimation(forKey: "Shaking")

        let positionAnimation = CAKeyframeAnimation()
        positionAnimation.keyPath = "position"
        positionAnimation.values = [view.layer.position, view.center]
        positionAnimation.keyTimes = [0, 1]
        
        let transformRotationAnimation = CAKeyframeAnimation()
        transformRotationAnimation.keyPath = "transform.rotation"
        guard let transformationZRotationValue = layer.value(forKeyPath: "transform.rotation.z") else {
            return
        }
        transformRotationAnimation.values = [transformationZRotationValue, 0]
        transformRotationAnimation.keyTimes = [0, 1]

        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [positionAnimation, transformRotationAnimation]
        animationGroup.duration = duration
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
   
        view.layer.add(animationGroup, forKey: "StopShacking")
    }
}
