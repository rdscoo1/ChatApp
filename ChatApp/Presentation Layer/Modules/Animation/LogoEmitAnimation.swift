//
//  LogoEmitAnimation.swift
//  ChatApp
//
//  Created by Roman Khodukin on 30.04.2021.
//

import UIKit

protocol IWindowAnimation {
    func emitOnTouch(at point: CGPoint)
}

class LogoEmitAnimation: IWindowAnimation {
    
    // MARK: - Private properties
    
    private weak var window: AnimatedUIWindow?
    
    private var emitterLayer: CAEmitterLayer {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.name = "EmitterLayer"
        emitterLayer.emitterShape = .line
        emitterLayer.beginTime = CACurrentMediaTime()
        emitterLayer.timeOffset = CFTimeInterval(arc4random_uniform(6) + 5)
        emitterLayer.emitterCells = [emitterCell]
        return emitterLayer
    }
    
    private let emitterCell: CAEmitterCell = {
        var emitterCell = CAEmitterCell()
        emitterCell.contents = UIImage.appLogo.cgImage
        emitterCell.birthRate = 2
        emitterCell.lifetime = 2
        emitterCell.lifetimeRange = 2
        emitterCell.emissionRange = .pi
        emitterCell.scale = 0.05
        emitterCell.scaleRange = 0.05
        emitterCell.velocity = -30
        emitterCell.velocityRange = 20
        emitterCell.spin = -0.5
        emitterCell.spinRange = 1.0
        return emitterCell
    }()
    
    // MARK: - Initializer
    
    init(window: AnimatedUIWindow) {
        self.window = window
    }
    
    // MARK: - IWindowAnimator
    
    func emitOnTouch(at point: CGPoint) {
        let layer = emitterLayer
        layer.position = point
        window?.layer.addSublayer(layer)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            layer.birthRate = 0
        }
        Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
            layer.removeFromSuperlayer()
        }
    }
}
