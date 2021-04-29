//
//  AnimatedUIWindow.swift
//  ChatApp
//
//  Created by Roman Khodukin on 30.04.2021.
//

import UIKit

class AnimatedUIWindow: UIWindow {
    
    // MARK: - Private properties
    
    private lazy var logoEmitAnimation = LogoEmitAnimation(window: self)
    
    // MARK: - Overrided methods
    
    override func sendEvent(_ event: UIEvent) {
        event.touches(for: self)?.forEach { touch in
            logoEmitAnimation.emitOnTouch(at: touch.location(in: self))
        }
        
        super.sendEvent(event)
    }
}
