//
//  SAHistoryNavigationViewController.swift
//  SAHistoryNavigationViewController
//
//  Created by 鈴木大貴 on 2015/03/26.
//  Copyright (c) 2015年 鈴木大貴. All rights reserved.
//

import UIKit

extension UINavigationController {
    public func showHistory() {}
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

public class SAHistoryNavigationViewController: UINavigationController {
    
    var historyViewController = SAHistoryViewController()
    
    private var coverView = UIView()
    private var screenshotImages = [UIImage]()
    
    private let kImageScale: CGFloat = 1.0
    
    override init() {
        super.init()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
    
    public override func viewDidLoad() {
        if let viewController = viewControllers.first as? UIViewController {
            screenshotImages += [viewController.view.screenshotImage(scale: kImageScale)]
        }
        
        coverView.backgroundColor = .grayColor()
        coverView.hidden = true
        NSLayoutConstraint.applyAutoLayout(view, target: coverView, index: nil, top: 0.0, left: 0.0, right: 0.0, bottom: 0.0, height: nil, width: nil)
        
        historyViewController.delegate = self
        historyViewController.view.hidden = true
        let width = UIScreen.mainScreen().bounds.size.width
        NSLayoutConstraint.applyAutoLayout(view, target: historyViewController.view, index: nil, top: 0.0, left: Float(-width), right: Float(-width), bottom: 0.0, height: nil, width: Float(width * 3))
    }
    
    public override func pushViewController(viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        screenshotImages += [viewController.view.screenshotImage(scale: kImageScale)]
    }
    
    public override func popViewControllerAnimated(animated: Bool) -> UIViewController? {
        screenshotImages.removeLast()
        return super.popViewControllerAnimated(animated)
    }
    
    public override func popToRootViewControllerAnimated(animated: Bool) -> [AnyObject]? {
        if let image = screenshotImages.first {
            screenshotImages.removeAll(keepCapacity: false)
            screenshotImages += [image]
        }
        return super.popToRootViewControllerAnimated(animated)
    }
    
    public override func popToViewController(viewController: UIViewController, animated: Bool) -> [AnyObject]? {
        var canRemove = false
        for (index, currentViewController) in enumerate(viewControllers) {
            if currentViewController as? UIViewController == viewController {
                canRemove = true
                continue
            }
            
            if canRemove {
                screenshotImages.removeAtIndex(index)
            }
        }
        return super.popToViewController(viewController, animated: animated)
    }
    
    public override func setViewControllers(viewControllers: [AnyObject]!, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        if let viewControllers = viewControllers as? [UIViewController] {
            for viewController in viewControllers {
                screenshotImages += [viewController.view.screenshotImage(scale: kImageScale)]
            }
        }
    }
    
    public override func showHistory() {
        
        super.showHistory()
        
        historyViewController.images = screenshotImages
        historyViewController.currentIndex = viewControllers.count - 1
        historyViewController.reload()
        historyViewController.view.hidden = false
        coverView.hidden = false
        
        setNavigationBarHidden(true, animated: true)
        UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseOut, animations: {
            self.historyViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.7, 0.7)
        }) { (finished) in
                
        }
    }
}

extension SAHistoryNavigationViewController: SAHistoryViewControllerDelegate {
    func didSelectIndex(index: Int) {
        
        let viewControllers = self.viewControllers
        var newViewControllers = [AnyObject]()
        for (currentIndex, viewController) in enumerate(viewControllers) {
            newViewControllers += [viewController]
            if currentIndex == index {
                break
            }
        }
        
        screenshotImages.removeAll(keepCapacity: false)
        setViewControllers(newViewControllers, animated: false)
        
        UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseOut, animations: {
            self.historyViewController.view.transform = CGAffineTransformIdentity
            self.historyViewController.scrollToIndex(index, animated: false)
        }) { (finished) in
            self.historyViewController.view.hidden = true
            self.coverView.hidden = true
            self.setNavigationBarHidden(false, animated: true)
        }
    }
}
