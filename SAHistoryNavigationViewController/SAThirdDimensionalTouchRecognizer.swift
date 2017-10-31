//
//  SAThirdDimensionalTouchRecognizer.swift
//  SAHistoryNavigationViewController
//
//  Created by 鈴木大貴 on 2015/10/27.
//  Copyright (c) 2015年 鈴木大貴. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass
import AudioToolbox.AudioServices

@available(iOS 9, *)
final class SAThirdDimensionalTouchRecognizer: UILongPressGestureRecognizer {
    enum SystemSoundVibrateID: SystemSoundID {
        case peek = 1519
        case pop  = 1520
        case nope = 1521
    }
    
    private(set) var percentage: CGFloat = 0
    var threshold: CGFloat = 1
    
    init(target: AnyObject?, action: Selector, threshold: CGFloat) {
        self.threshold = threshold
        super.init(target: target, action: action)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        guard let touch = touches.first else {
            return
        }
        percentage = max(0, min(1, touch.force / touch.maximumPossibleForce))
        if percentage > threshold && state == .changed {
            state = .ended
            AudioServicesPlayAlertSound(SystemSoundVibrateID.pop.rawValue)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        state = .failed
    }
    
    override func reset() {
        super.reset()
        percentage = 0
    }
}
