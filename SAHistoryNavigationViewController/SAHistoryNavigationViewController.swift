//
//  SAHistoryNavigationViewController.swift
//  SAHistoryNavigationViewController
//
//  Created by 鈴木大貴 on 2015/03/26.
//  Copyright (c) 2015年 鈴木大貴. All rights reserved.
//

import UIKit

extension UINavigationController {
    public weak var historyDelegate: SAHistoryNavigationViewControllerDelegate? {
        set {
            willSetHistoryDelegate(newValue)
        }
        get {
            return willGetHistoryDelegate()
        }
    }
    public func showHistory() {}
    public func setHistoryBackgroundColor(color: UIColor) {}
    public func contentView() -> UIView? { return nil }
    func willSetHistoryDelegate(delegate: SAHistoryNavigationViewControllerDelegate?) {}
    func willGetHistoryDelegate() -> SAHistoryNavigationViewControllerDelegate? { return nil }
}

extension UIView {
    func screenshotImage(scale: CGFloat = 0.0) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
        drawViewHierarchyInRect(bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIViewController {
    func screenshotFromWindow(scale: CGFloat = 0.0) -> UIImage? {
        guard let window = UIApplication.sharedApplication().windows.first else {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(window.frame.size, false, scale)
        window.drawViewHierarchyInRect(window.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

@objc public protocol SAHistoryNavigationViewControllerDelegate: NSObjectProtocol {
    optional func historyControllerDidShowHistory(controller: SAHistoryNavigationViewController, viewController: UIViewController)
}

public class SAHistoryNavigationViewController: UINavigationController {
    private static let kImageScale: CGFloat = 1.0
    
    public var thirdDimensionalTouchThreshold: CGFloat = 0.5

    private var interactiveTransition: UIPercentDrivenInteractiveTransition?    
    private var screenshots = [UIImage]()
    private var historyViewController: SAHistoryViewController?
    private let historyContentView = UIView()
    private weak var _historyDelegate: SAHistoryNavigationViewControllerDelegate?

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override public init(navigationBarClass: AnyClass!, toolbarClass: AnyClass!) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override public init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        historyContentView.backgroundColor = .grayColor()
        
        let gestureRecognizer: UIGestureRecognizer
        if #available(iOS 9, *) {
            if traitCollection.forceTouchCapability == .Available {
                interactiveTransition = UIPercentDrivenInteractiveTransition()
                gestureRecognizer = SAThirdDimensionalTouchRecognizer(target: self, action: "handleThirdDimensionalTouch:", threshold: thirdDimensionalTouchThreshold)
                (gestureRecognizer as? SAThirdDimensionalTouchRecognizer)?.minimumPressDuration = 0.2
            } else {
                gestureRecognizer = UILongPressGestureRecognizer(target: self, action: "detectLongTap:")
            }
        } else {
            gestureRecognizer = UILongPressGestureRecognizer(target: self, action: "detectLongTap:")
        }
        gestureRecognizer.delegate = self
        navigationBar.addGestureRecognizer(gestureRecognizer)
        
        navigationBar.delegate = self
    }
    
    override func willSetHistoryDelegate(delegate: SAHistoryNavigationViewControllerDelegate?) {
        _historyDelegate = delegate
    }
    
    override func willGetHistoryDelegate() -> SAHistoryNavigationViewControllerDelegate? {
        return _historyDelegate
    }
    
    override public func pushViewController(viewController: UIViewController, animated: Bool) {
        if let image = visibleViewController?.screenshotFromWindow(SAHistoryNavigationViewController.kImageScale) {
            screenshots += [image]
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    public override func popToRootViewControllerAnimated(animated: Bool) -> [UIViewController]? {
        screenshots.removeAll(keepCapacity: false)
        return super.popToRootViewControllerAnimated(animated)
    }
    
    public override func popToViewController(viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let vcs = super.popToViewController(viewController, animated: animated)
        if let index = viewControllers.indexOf(viewController) {
            screenshots.removeRange(index..<screenshots.count)
        }
        return vcs
    }
    
    public override func setViewControllers(viewControllers: [UIViewController], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        for (currentIndex, viewController) in viewControllers.enumerate() {
            if currentIndex == viewControllers.endIndex {
                break
            }
            if let image = viewController.screenshotFromWindow(SAHistoryNavigationViewController.kImageScale) {
                screenshots += [image]
            }
        }
    }
    
    @available(iOS 9, *)
    func handleThirdDimensionalTouch(gesture: SAThirdDimensionalTouchRecognizer) {
        switch gesture.state {
        case .Began:
            guard let image = visibleViewController?.screenshotFromWindow(SAHistoryNavigationViewController.kImageScale) else {
                return
            }
            screenshots += [image]
            
            let historyViewController = createHistoryViewController()
            self.historyViewController = historyViewController
            presentViewController(historyViewController, animated: true, completion: nil)
            
        case .Changed:
            interactiveTransition?.updateInteractiveTransition(min(gesture.threshold, max(0, gesture.percentage)))
            
        case .Ended:
            screenshots.removeLast()
            if gesture.percentage >= gesture.threshold {
                interactiveTransition?.finishInteractiveTransition()
                guard let visibleViewController = self.visibleViewController else {
                    return
                }
                historyDelegate?.historyControllerDidShowHistory?(self, viewController: visibleViewController)
            } else {
                interactiveTransition?.cancelInteractiveTransition()
            }
        
        case .Cancelled, .Failed, .Possible:
            screenshots.removeLast()
        }
    }
    
    func detectLongTap(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .Began {
            showHistory()
        }
    }
    
    private func createHistoryViewController() -> SAHistoryViewController {
        let historyViewController = SAHistoryViewController()
        historyViewController.delegate = self
        historyViewController.contentView = historyContentView
        historyViewController.images = screenshots
        historyViewController.currentIndex = viewControllers.count - 1
        historyViewController.transitioningDelegate = self
        return historyViewController
    }
}

extension SAHistoryNavigationViewController {
    override public func showHistory() {
        guard let image = visibleViewController?.screenshotFromWindow(SAHistoryNavigationViewController.kImageScale) else {
            return
        }
        screenshots += [image]
        let historyViewController = createHistoryViewController()
        self.historyViewController = historyViewController
        setNavigationBarHidden(true, animated: false)
        presentViewController(historyViewController, animated: true) {
            guard let visibleViewController = self.visibleViewController else {
                return
            }
            self.historyDelegate?.historyControllerDidShowHistory?(self, viewController: visibleViewController)
        }
    }
    
    override public func setHistoryBackgroundColor(color: UIColor) {
        historyContentView.backgroundColor = color
    }
    
    override public func contentView() -> UIView? {
        return historyContentView
    }
}

extension SAHistoryNavigationViewController: UINavigationBarDelegate {
    public func navigationBar(navigationBar: UINavigationBar, didPopItem item: UINavigationItem) {
        guard let items = navigationBar.items else {
            return
        }
        screenshots.removeRange(items.count..<screenshots.count)
    }
}

extension SAHistoryNavigationViewController : UIViewControllerTransitioningDelegate {
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SAHistoryViewAnimatedTransitioning(isPresenting: true)
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SAHistoryViewAnimatedTransitioning(isPresenting: false)
    }
    
    public func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition
    }
}

extension SAHistoryNavigationViewController: SAHistoryViewControllerDelegate {
    func historyViewController(viewController: SAHistoryViewController, didSelectIndex index: Int) {
        if viewControllers.count - 1 < index {
            return
        }
        
        viewController.dismissViewControllerAnimated(true) { finished in
            self.popToViewController(self.viewControllers[index], animated: false)
            self.historyViewController = nil
            self.setNavigationBarHidden(false, animated: false)
        }
    }
}

extension SAHistoryNavigationViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let _ = visibleViewController?.navigationController?.navigationBar.backItem, view = gestureRecognizer.view as? UINavigationBar {
            var height = 64.0
            if visibleViewController?.navigationController?.navigationBarHidden == true {
                height = 44.0
            }
            let backButtonFrame = CGRect(x: 0.0, y :0.0,  width: 100.0, height: height)
            let touchPoint = gestureRecognizer.locationInView(view)
            if CGRectContainsPoint(backButtonFrame, touchPoint) {
                return true
            }
        }
        
        if let gestureRecognizer = gestureRecognizer as? UIScreenEdgePanGestureRecognizer {
            if view == gestureRecognizer.view {
                return true
            }
        }
        
        return false
    }
}