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
class SAThirdDimensionalTouchRecognizer: UILongPressGestureRecognizer {
    
    private let kSystemSoundID_Vibrate_Peek: SystemSoundID = 1519
    private let kSystemSoundID_Vibrate_Pop: SystemSoundID = 1520
    private let kSystemSoundID_Vibrate_Nope: SystemSoundID = 1521
    
    
    fileprivate(set) var percentage: CGFloat = 0
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
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate_Pop)
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
