//
//  SAHistoryViewAnimatedTransitioning.swift
//  SAHistoryNavigationViewController
//
//  Created by 鈴木大貴 on 2015/10/26.
//  Copyright (c) 2015年 鈴木大貴. All rights reserved.
//

import UIKit

class SAHistoryViewAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    //MARK: - Static Constants
    fileprivate struct Const {
        static let duration: TimeInterval = 0.25
        static let scale: CGFloat = 0.7
    }
    
    //MARK: - Properties
    fileprivate var isPresenting = true
    
    //MARK: - Initializers
    init(isPresenting: Bool) {
        super.init()
        self.isPresenting = isPresenting
    }
    
    //MARK - Life cycle
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Const.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        else { return }
        let containerView = transitionContext.containerView
        if isPresenting {
            pushAniamtion(transitionContext, containerView: containerView, toVC: toVC, fromVC: fromVC)
            return
        }
        popAniamtion(transitionContext, containerView: containerView, toVC: toVC, fromVC: fromVC)
    }

    //MARK: - Animations
    fileprivate func pushAniamtion(_ transitionContext: UIViewControllerContextTransitioning, containerView: UIView, toVC: UIViewController, fromVC: UIViewController) {
        guard let hvc = toVC as? SAHistoryViewController else { return }
        
        containerView.addSubview(toVC.view)
        fromVC.view.isHidden = true
        hvc.view.frame = containerView.bounds
        hvc.collectionView.transform = CGAffineTransform.identity

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseOut, animations: {
            hvc.collectionView.transform = CGAffineTransform(scaleX: Const.scale, y: Const.scale)
        }) { finished in
            let cancelled = transitionContext.transitionWasCancelled
            if cancelled {
                fromVC.view.isHidden = false
                hvc.collectionView.transform = CGAffineTransform.identity
                hvc.view.removeFromSuperview()
            } else {
                hvc.view.isHidden = false
                fromVC.view.removeFromSuperview()
            }
            transitionContext.completeTransition(!cancelled)
        }
    }
    
    fileprivate func popAniamtion(_ transitionContext: UIViewControllerContextTransitioning, containerView: UIView, toVC: UIViewController, fromVC: UIViewController) {
        guard let hvc = fromVC as? SAHistoryViewController else { return }
        
        containerView.addSubview(toVC.view)
        toVC.view.isHidden = true
        hvc.view.frame = containerView.bounds
        hvc.collectionView.transform = CGAffineTransform(scaleX: Const.scale, y: Const.scale)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseOut, animations: {
            hvc.collectionView.transform = CGAffineTransform.identity
            hvc.scrollToSelectedIndex(false)
        }) { finished in
            let cancelled = transitionContext.transitionWasCancelled
            if cancelled {
                hvc.collectionView.transform = CGAffineTransform.identity
                toVC.view.removeFromSuperview()
            } else {
                toVC.view.isHidden = false
                hvc.view.removeFromSuperview()
            }
            transitionContext.completeTransition(!cancelled)
        }
    }
}
