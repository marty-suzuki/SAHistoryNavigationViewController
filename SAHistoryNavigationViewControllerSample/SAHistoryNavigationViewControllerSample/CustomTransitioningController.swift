//
//  CustomTransitioningController.swift
//  SAHistoryNavigationViewControllerSample
//
//  Created by 鈴木 大貴 on 2015/08/05.
//  Copyright (c) 2015年 &#37428;&#26408;&#22823;&#36020;. All rights reserved.
//

import UIKit

class CustomTransitioningController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private(set) var navigationControllerOperation: UINavigationControllerOperation
    private var currentTransitionContext: UIViewControllerContextTransitioning?
    private var backgroundView: UIView?
    private var alphaView: UIView?
    
    private static let kDefaultScale: CGFloat = 0.8
    private static let kDefaultDuration: NSTimeInterval = 0.3
    
    required init(operation: UINavigationControllerOperation) {
        navigationControllerOperation = operation
        super.init()
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return CustomTransitioningController.kDefaultDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let
            containerView = transitionContext.containerView(),
            toView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)?.view,
            fromView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view
        else {
            return
        }
        
        currentTransitionContext = transitionContext
        switch navigationControllerOperation {
        case .Push:
            pushAnimation(transitionContext, toView: toView, fromView: fromView, containerView: containerView)
        case .Pop:
            popAnimation(transitionContext, toView: toView, fromView: fromView, containerView: containerView)
        case .None:
            let cancelled = transitionContext.transitionWasCancelled()
            transitionContext.completeTransition(!cancelled)
        }
    }
}

//MARK: - Internal Methods
extension CustomTransitioningController {
    func forceFinish() {
        let navigationControllerOperation = self.navigationControllerOperation
        if let backgroundView = backgroundView, alphaView = alphaView {
            let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64((CustomTransitioningController.kDefaultDuration + 0.1) * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue()) { [weak self] in
                if let currentTransitionContext = self?.currentTransitionContext {
                    
                    let toViewContoller = currentTransitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
                    let fromViewContoller = currentTransitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
                    
                    if let fromView = fromViewContoller?.view, toView = toViewContoller?.view {
                        switch navigationControllerOperation {
                        case .Push:
                            self?.pushAniamtionCompletion(currentTransitionContext, toView: toView, fromView: fromView, backgroundView: backgroundView, alphaView: alphaView)
                        case .Pop:
                            self?.popAniamtionCompletion(currentTransitionContext, toView: toView, fromView: fromView, backgroundView: backgroundView, alphaView: alphaView)
                        case .None:
                            let cancelled = currentTransitionContext.transitionWasCancelled()
                            currentTransitionContext.completeTransition(!cancelled)
                        }
                        self?.currentTransitionContext = nil
                        self?.backgroundView = nil
                        self?.alphaView = nil
                    }
                }
            }
        }
    }
}

//MARK: - Private Methods
extension CustomTransitioningController {
    private func popAnimation(transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView, containerView: UIView) {
        
        let backgroundView = UIView(frame: containerView.bounds)
        backgroundView.backgroundColor = .blackColor()
        containerView.addSubview(backgroundView)
        self.backgroundView = backgroundView
        
        toView.frame = containerView.bounds
        containerView.addSubview(toView)
        
        let alphaView = UIView(frame: containerView.bounds)
        alphaView.backgroundColor = .blackColor()
        containerView.addSubview(alphaView)
        self.alphaView = alphaView
        
        fromView.frame = containerView.bounds
        containerView.addSubview(fromView)
        
        let completion: (Bool) -> Void = { [weak self] finished in
            if finished {
                self?.popAniamtionCompletion(transitionContext, toView: toView, fromView: fromView, backgroundView: backgroundView, alphaView: alphaView)
            }
        }
        
        let kDefaultScale = CustomTransitioningController.kDefaultScale
        toView.transform = CGAffineTransformScale(CGAffineTransformIdentity, kDefaultScale, kDefaultScale)
        alphaView.alpha = 0.7
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, options: .CurveEaseOut, animations: {
            
            toView.transform = CGAffineTransformIdentity
            fromView.frame.origin.x = containerView.frame.size.width
            alphaView.alpha = 0.0
            
            }, completion: completion)
        
    }
    
    private func popAniamtionCompletion(transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView, backgroundView: UIView, alphaView: UIView) {
        let cancelled = transitionContext.transitionWasCancelled()
        if cancelled {
            toView.transform = CGAffineTransformIdentity
            toView.removeFromSuperview()
        } else {
            fromView.removeFromSuperview()
        }
        
        backgroundView.removeFromSuperview()
        alphaView.removeFromSuperview()
        
        transitionContext.completeTransition(!cancelled)
        
        currentTransitionContext = nil
        self.backgroundView = nil
        self.alphaView = nil
    }
    
    private func pushAnimation(transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView, containerView: UIView) {
        
        let backgroundView = UIView(frame: containerView.bounds)
        backgroundView.backgroundColor = .blackColor()
        containerView.addSubview(backgroundView)
        self.backgroundView = backgroundView
        
        fromView.frame = containerView.bounds
        containerView.addSubview(fromView)
        
        let alphaView = UIView(frame: containerView.bounds)
        alphaView.backgroundColor = .blackColor()
        alphaView.alpha = 0.0
        containerView.addSubview(alphaView)
        self.alphaView = alphaView
        
        toView.frame = containerView.bounds
        toView.frame.origin.x = containerView.frame.size.width
        containerView.addSubview(toView)
        
        let completion: (Bool) -> Void = { [weak self] finished in
            if finished {
                self?.pushAniamtionCompletion(transitionContext, toView: toView, fromView: fromView, backgroundView: backgroundView, alphaView: alphaView)
            }
        }
        
        let kDefaultScale = CustomTransitioningController.kDefaultScale
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, options: .CurveEaseOut, animations: {
            
            fromView.transform = CGAffineTransformScale(CGAffineTransformIdentity, kDefaultScale, kDefaultScale)
            toView.frame.origin.x = 0.0
            alphaView.alpha = 0.7
            
            }, completion: completion)
    }
    
    private func pushAniamtionCompletion(transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView, backgroundView: UIView, alphaView: UIView) {
        let cancelled = transitionContext.transitionWasCancelled()
        if cancelled {
            toView.removeFromSuperview()
        }
        
        fromView.transform = CGAffineTransformIdentity
        backgroundView.removeFromSuperview()
        fromView.removeFromSuperview()
        alphaView.removeFromSuperview()
        
        transitionContext.completeTransition(!cancelled)
        
        currentTransitionContext = nil
        self.backgroundView = nil
        self.alphaView = nil
    }
}

