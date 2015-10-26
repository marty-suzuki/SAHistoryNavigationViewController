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
    
    internal var historyContentView = UIView()
    internal var historyViewController = SAHistoryViewController()
    
    private var screenshots = [UIImage]()
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
        historyContentView.hidden = true
        NSLayoutConstraint.applyAutoLayout(view, target: historyContentView, index: nil, top: 0.0, left: 0.0, right: 0.0, bottom: 0.0, height: nil, width: nil)
        
        historyViewController.delegate = self
        historyViewController.view.alpha = 0.0
        let width = UIScreen.mainScreen().bounds.size.width
        NSLayoutConstraint.applyAutoLayout(view, target: historyViewController.view, index: nil, top: 0.0, left: Float(-width), right: Float(-width), bottom: 0.0, height: nil, width: Float(width * 3))
        
        let  longPressGesture = UILongPressGestureRecognizer(target: self, action: "detectLongTap:")
        longPressGesture.delegate = self
        navigationBar.addGestureRecognizer(longPressGesture)
        
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
        if let index = viewControllers.indexOf(viewController) {
                screenshots.removeRange(index..<screenshots.count)
        }
        return super.popToViewController(viewController, animated: animated)
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
}

extension SAHistoryNavigationViewController: UINavigationBarDelegate {
    public func navigationBar(navigationBar: UINavigationBar, didPopItem item: UINavigationItem) {
        guard let items = navigationBar.items else {
            return
        }
        screenshots.removeRange(items.count..<screenshots.count)
    }
}

extension SAHistoryNavigationViewController {
    override public func showHistory() {
        guard let image = visibleViewController?.screenshotFromWindow(SAHistoryNavigationViewController.kImageScale) else {
            return
        }
        
        screenshots += [image]
        
        historyViewController.images = screenshots
        historyViewController.currentIndex = viewControllers.count - 1
        historyViewController.reload()
        historyViewController.view.alpha = 1.0
        
        historyContentView.hidden = false
        
        setNavigationBarHidden(true, animated: false)
        UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseOut, animations: {
            self.historyViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.7, 0.7)
        }) { _ in
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
    
    func detectLongTap(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .Began {
            showHistory()
        }
    }
}

extension SAHistoryNavigationViewController: SAHistoryViewControllerDelegate {
    func didSelectIndex(index: Int) {
        var destinationViewController: UIViewController?
        for (currentIndex, viewController) in viewControllers.enumerate() {
            if currentIndex == index {
                destinationViewController = viewController
                break
            }
        }

        if let viewController = destinationViewController {
            popToViewController(viewController, animated: false)
        }
        
        UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseOut, animations: {
            self.historyViewController.view.transform = CGAffineTransformIdentity
            self.historyViewController.scrollToIndex(index, animated: false)
        }) { finished in
            self.historyContentView.hidden = true
            self.historyViewController.view.alpha = 0.0
            self.setNavigationBarHidden(false, animated: false)
        }
    }
}

extension SAHistoryNavigationViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let _ = visibleViewController?.navigationController?.navigationBar.backItem {
            var height = 64.0
            if visibleViewController?.navigationController?.navigationBarHidden == true {
                height = 44.0
            }
            let backButtonFrame = CGRect(x: 0.0, y :0.0,  width: 100.0, height: height)
            let touchPoint = gestureRecognizer.locationInView(gestureRecognizer.view)
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