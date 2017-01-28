//
//  SAHistoryNavigationViewController.swift
//  SAHistoryNavigationViewController
//
//  Created by 鈴木大貴 on 2015/03/26.
//  Copyright (c) 2015年 鈴木大貴. All rights reserved.
//

import UIKit

@objc public protocol SAHistoryNavigationViewControllerDelegate: NSObjectProtocol {
    @objc optional func historyControllerDidShowHistory(_ controller: SAHistoryNavigationViewController, viewController: UIViewController)
}

open class SAHistoryNavigationViewController: UINavigationController {
    //MARK: - Static constants
    fileprivate struct Const {
        static let imageScale: CGFloat = 1.0
    }
        
    //MARK: - Properties
    open var thirdDimensionalTouchThreshold: CGFloat = 0.5

    fileprivate var interactiveTransition: UIPercentDrivenInteractiveTransition?    
    fileprivate var screenshots = [UIImage]()
    fileprivate var historyViewController: SAHistoryViewController?
    fileprivate let historyContentView = UIView()
    public weak var historyDelegate: SAHistoryNavigationViewControllerDelegate?
    public var historyBackgroundColor: UIColor? {
        get {
            return historyContentView.backgroundColor
        }
        set {
            historyContentView.backgroundColor = newValue
        }
    }
    public var contentView: UIView? {
        return historyContentView
    }

    //MARK: - Initializers
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override public init(navigationBarClass: AnyClass!, toolbarClass: AnyClass!) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override public init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    //MARK: Life cycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if historyContentView.backgroundColor == nil {
            historyContentView.backgroundColor = .gray
        }
        
        let gestureRecognizer: UIGestureRecognizer
        if #available(iOS 9, *) {
            if traitCollection.forceTouchCapability == .available {
                interactiveTransition = UIPercentDrivenInteractiveTransition()
                gestureRecognizer = SAThirdDimensionalTouchRecognizer(target: self, action: #selector(SAHistoryNavigationViewController.handleThirdDimensionalTouch(_:)), threshold: thirdDimensionalTouchThreshold)
                (gestureRecognizer as? SAThirdDimensionalTouchRecognizer)?.minimumPressDuration = 0.2
            } else {
                gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(SAHistoryNavigationViewController.detectLongTap(_:)))
            }
        } else {
            gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(SAHistoryNavigationViewController.detectLongTap(_:)))
        }
        gestureRecognizer.delegate = self
        navigationBar.addGestureRecognizer(gestureRecognizer)
    }
    
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if let image = visibleViewController?.sah.screenshotFromWindow(Const.imageScale) {
            screenshots += [image]
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    open override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        screenshots.removeAll(keepingCapacity: false)
        return super.popToRootViewController(animated: animated)
    }
    
    open override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let vcs = super.popToViewController(viewController, animated: animated)
        if let index = viewControllers.index(of: viewController) {
            screenshots.removeSubrange(index..<screenshots.count)
        }
        return vcs
    }
    
    open override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        for (currentIndex, viewController) in viewControllers.enumerated() {
            if currentIndex == viewControllers.endIndex { break }
            guard let image = viewController.sah.screenshotFromWindow(Const.imageScale) else { continue }
            screenshots += [image]
        }
    }
    
    @available(iOS 9, *)
    func handleThirdDimensionalTouch(_ gesture: SAThirdDimensionalTouchRecognizer) {
        switch gesture.state {
        case .began:
            guard let image = visibleViewController?.sah.screenshotFromWindow(Const.imageScale) else { return }
            screenshots += [image]
            
            let historyViewController = createHistoryViewController()
            self.historyViewController = historyViewController
            present(historyViewController, animated: true, completion: nil)
            
        case .changed:
            interactiveTransition?.update(min(gesture.threshold, max(0, gesture.percentage)))
            
        case .ended:
            screenshots.removeLast()
            if gesture.percentage >= gesture.threshold {
                interactiveTransition?.finish()
                guard let visibleViewController = self.visibleViewController else { return }
                historyDelegate?.historyControllerDidShowHistory?(self, viewController: visibleViewController)
            } else {
                interactiveTransition?.cancel()
            }
        
        case .cancelled, .failed, .possible:
            screenshots.removeLast()
        }
    }
    
    func detectLongTap(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            showHistory()
        }
    }
    
    fileprivate func createHistoryViewController() -> SAHistoryViewController {
        let historyViewController = SAHistoryViewController()
        historyViewController.delegate = self
        historyViewController.contentView = historyContentView
        historyViewController.images = screenshots
        historyViewController.currentIndex = viewControllers.count - 1
        historyViewController.transitioningDelegate = self
        return historyViewController
    }

    public func showHistory() {
        guard let image = visibleViewController?.sah.screenshotFromWindow(Const.imageScale) else { return }
        screenshots += [image]
        let historyViewController = createHistoryViewController()
        self.historyViewController = historyViewController
        setNavigationBarHidden(true, animated: false)
        present(historyViewController, animated: true) {
            guard let visibleViewController = self.visibleViewController else { return }
            self.historyDelegate?.historyControllerDidShowHistory?(self, viewController: visibleViewController)
        }
    }
}

//MARK: - UINavigationBarDelegate
extension SAHistoryNavigationViewController: UINavigationBarDelegate {
    public func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem) {
        guard let items = navigationBar.items else { return }
        screenshots.removeSubrange(items.count..<screenshots.count)
    }
}

//MARK: - UIViewControllerTransitioningDelegate
extension SAHistoryNavigationViewController : UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SAHistoryViewAnimatedTransitioning(isPresenting: true)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SAHistoryViewAnimatedTransitioning(isPresenting: false)
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition
    }
}

//MARK: - SAHistoryViewControllerDelegate
extension SAHistoryNavigationViewController: SAHistoryViewControllerDelegate {
    func historyViewController(_ viewController: SAHistoryViewController, didSelectIndex index: Int) {
        if viewControllers.count - 1 < index { return }
        viewController.dismiss(animated: true) { _ in
            _ = self.popToViewController(self.viewControllers[index], animated: false)
            self.historyViewController = nil
            self.setNavigationBarHidden(false, animated: false)
        }
    }
}

//MRAK: - UIGestureRecognizerDelegate
extension SAHistoryNavigationViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let _ = visibleViewController?.navigationController?.navigationBar.backItem, let view = gestureRecognizer.view as? UINavigationBar {
            let height = visibleViewController?.navigationController?.isNavigationBarHidden == true ? 44.0 : 64.0
            let backButtonFrame = CGRect(x: 0.0, y :0.0,  width: 100.0, height: height)
            let touchPoint = gestureRecognizer.location(in: view)
            if backButtonFrame.contains(touchPoint) {
                return true
            }
        }
        if let gestureRecognizer = gestureRecognizer as? UIScreenEdgePanGestureRecognizer , view == gestureRecognizer.view {
            return true
        }
        return false
    }
}
