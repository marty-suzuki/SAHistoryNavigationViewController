//
//  SAHistoryNavigationTransitionController.swift
//  SAHistoryNavigationViewController
//
//  Created by 鈴木大貴 on 2015/05/26.
//  Copyright (c) 2015年 鈴木大貴. All rights reserved.
//

import UIKit

class SAHistoryNavigationTransitionController: NSObject, UIViewControllerAnimatedTransitioning {
    //MARK: - Static constants
    fileprivate struct Const {
        static let defaultDuration: TimeInterval = 0.3
    }
        
    //MARK: - Properties
    fileprivate(set) var navigationControllerOperation: UINavigationControllerOperation
    fileprivate var currentTransitionContext: UIViewControllerContextTransitioning?
    fileprivate var backgroundView: UIView?
    fileprivate var alphaView: UIView?
    
    //MARK: - Initializers
    required init(operation: UINavigationControllerOperation) {
        navigationControllerOperation = operation
        super.init()
    }
    
    //MARK: Life cycle
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Const.defaultDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view,
            let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view
        else { return }
        
        let containerView = transitionContext.containerView
        currentTransitionContext = transitionContext
        switch navigationControllerOperation {
            case .push:
                pushAnimation(transitionContext, toView: toView, fromView: fromView, containerView: containerView)
            case .pop:
                popAnimation(transitionContext, toView: toView, fromView: fromView, containerView: containerView)
            case .none:
                let cancelled = transitionContext.transitionWasCancelled
                transitionContext.completeTransition(!cancelled)
        }
    }

    func forceFinish() {
        let navigationControllerOperation = self.navigationControllerOperation
        guard let backgroundView = backgroundView, let alphaView = alphaView else { return }
        let dispatchTime = DispatchTime.now() + Double(Int64((Const.defaultDuration + 0.1) * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) { [weak self] in
            guard let currentTransitionContext = self?.currentTransitionContext else { return }
            let toViewContoller = currentTransitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            let fromViewContoller = currentTransitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
                
            guard let fromView = fromViewContoller?.view, let toView = toViewContoller?.view else { return }
            switch navigationControllerOperation {
                case .push:
                    self?.pushAniamtionCompletion(currentTransitionContext, toView: toView, fromView: fromView, backgroundView: backgroundView, alphaView: alphaView)
                case .pop:
                    self?.popAniamtionCompletion(currentTransitionContext, toView: toView, fromView: fromView, backgroundView: backgroundView, alphaView: alphaView)
                case .none:
                    let cancelled = currentTransitionContext.transitionWasCancelled
                    currentTransitionContext.completeTransition(!cancelled)
            }
            self?.currentTransitionContext = nil
            self?.backgroundView = nil
            self?.alphaView = nil
        }
    }

    //MARK: - Pop animations
    fileprivate func popAnimation(_ transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView, containerView: UIView) {
        let backgroundView = UIView(frame: containerView.bounds)
        backgroundView.backgroundColor = .black
        containerView.addSubview(backgroundView)
        self.backgroundView = backgroundView
        
        toView.frame = containerView.bounds
        containerView.addSubview(toView)
        
        let alphaView = UIView(frame: containerView.bounds)
        alphaView.backgroundColor = .black
        containerView.addSubview(alphaView)
        self.alphaView = alphaView
        
        fromView.frame = containerView.bounds
        containerView.addSubview(fromView)
        
        let completion: (Bool) -> Void = { [weak self] finished in
            if finished {
                self?.popAniamtionCompletion(transitionContext, toView: toView, fromView: fromView, backgroundView: backgroundView, alphaView: alphaView)
            }
        }
        
        toView.frame.origin.x = -(toView.frame.size.width / 4.0)
        alphaView.alpha = 0.4
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .curveEaseOut, animations: {
            toView.frame.origin.x = 0
            fromView.frame.origin.x = containerView.frame.size.width
            alphaView.alpha = 0.0
        }, completion: completion)
    }
    
    fileprivate func popAniamtionCompletion(_ transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView, backgroundView: UIView, alphaView: UIView) {
        let cancelled = transitionContext.transitionWasCancelled
        if cancelled {
            toView.transform = CGAffineTransform.identity
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

    //MARK: - pushAnimations
    fileprivate func pushAnimation(_ transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView, containerView: UIView) {
        let backgroundView = UIView(frame: containerView.bounds)
        backgroundView.backgroundColor = .black
        containerView.addSubview(backgroundView)
        self.backgroundView = backgroundView
        
        fromView.frame = containerView.bounds
        containerView.addSubview(fromView)
        
        let alphaView = UIView(frame: containerView.bounds)
        alphaView.backgroundColor = .black
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
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .curveEaseOut, animations: {
            fromView.frame.origin.x = -(fromView.frame.size.width / 4.0)
            toView.frame.origin.x = 0.0
            alphaView.alpha = 0.4
        }, completion: completion)
    }
    
    fileprivate func pushAniamtionCompletion(_ transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView, backgroundView: UIView, alphaView: UIView) {
        let cancelled = transitionContext.transitionWasCancelled
        if cancelled {
            toView.removeFromSuperview()
        }
        
        fromView.transform = CGAffineTransform.identity
        backgroundView.removeFromSuperview()
        fromView.removeFromSuperview()
        alphaView.removeFromSuperview()
        
        transitionContext.completeTransition(!cancelled)
        
        currentTransitionContext = nil
        self.backgroundView = nil
        self.alphaView = nil
    }
}
