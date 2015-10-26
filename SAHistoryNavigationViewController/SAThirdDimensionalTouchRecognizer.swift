//
//  SAThirdDimensionalTouchRecognizer.swift
//  SAHistoryNavigationViewController
//
//  Created by 鈴木大貴 on 2015/10/27.
//  Copyright (c) 2015年 鈴木大貴. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

@available(iOS 9, *)
class SAThirdDimensionalTouchRecognizer: UIGestureRecognizer {
    private(set) var percentage: CGFloat = 0
    
    override init(target: AnyObject?, action: Selector) {
        super.init(target: target, action: action)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        state = .Began
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        state = .Changed
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        state = .Ended
    }
    
    override func touchesCancelled(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesCancelled(touches, withEvent: event)
        state = .Changed
    }
    
    override func reset() {
        super.reset()
        state = .Possible
    }
}
