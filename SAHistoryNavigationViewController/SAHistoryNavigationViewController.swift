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
  public func setHistoryBackgroundColor(color: UIColor) {}
  public func contentView() -> UIView? { return nil }
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
    if let window = UIApplication.sharedApplication().windows.first as? UIWindow {
      UIGraphicsBeginImageContextWithOptions(window.frame.size, false, scale)
      window.drawViewHierarchyInRect(window.bounds, afterScreenUpdates: true)
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return image
    }
    return nil
  }
}

public class SAHistoryNavigationViewController: UINavigationController {

  private static let kImageScale: CGFloat = 1.0

  var historyViewController = SAHistoryViewController()

  public var historyContentView = UIView()
  //FIXME: handle rotation

  private var coverView = UIView()
  private var screenshotImages = [UIImage]()
  private var isSwiping = false


  override public func viewDidLoad() {
    super.viewDidLoad()

    coverView.backgroundColor = .grayColor()
    coverView.hidden = true
    NSLayoutConstraint.applyAutoLayout(view, target: coverView, index: nil, top: 0.0, left: 0.0, right: 0.0, bottom: 0.0, height: nil, width: nil)

    historyContentView.backgroundColor = .clearColor()
    historyContentView.hidden = true
    NSLayoutConstraint.applyAutoLayout(view, target: historyContentView, index: nil, top: 0.0, left: 0.0, right: 0.0, bottom: 0.0, height: nil, width: nil)

    historyViewController.delegate = self
    historyViewController.view.alpha = 0.0
    let width = UIScreen.mainScreen().bounds.size.width

    //???: width * 3??
    NSLayoutConstraint.applyAutoLayout(view, target: historyViewController.view, index: nil, top: 0.0, left: Float(-width), right: Float(-width), bottom: 0.0, height: nil, width: Float(width * 3))

    let  longPressGesture = UILongPressGestureRecognizer(target: self, action: "detectLongTap:")
    longPressGesture.delegate = self
    navigationBar.addGestureRecognizer(longPressGesture)

    navigationBar.delegate = self

    delegate = self

    interactivePopGestureRecognizer.addTarget(self, action: "popGestureRecognized:")
  }

  override public func pushViewController(viewController: UIViewController, animated: Bool) {
    if let image = visibleViewController.screenshotFromWindow(scale: SAHistoryNavigationViewController.kImageScale) {
      screenshotImages += [image]
    }
    super.pushViewController(viewController, animated: animated)
  }

//  override public func popViewControllerAnimated(animated: Bool) -> UIViewController? {
//    //FIXME:
//    if !isSwiping {
//      screenshotImages.removeLast()
//    }
//    //        }
//    return super.popViewControllerAnimated(animated)
//  }

  override public func popToRootViewControllerAnimated(animated: Bool) -> [AnyObject]? {
    screenshotImages.removeAll(keepCapacity: false)
    return super.popToRootViewControllerAnimated(animated)
  }

  override public func popToViewController(viewController: UIViewController, animated: Bool) -> [AnyObject]? {
    var index: Int?
    for (currentIndex, currentViewController) in enumerate(viewControllers) {
      if currentViewController as? UIViewController == viewController {
        index = currentIndex
        break
      }
    }

    var removeList = [Bool]()
    for (currentIndex, image) in enumerate(screenshotImages) {
      if currentIndex >= index {
        removeList += [true]
      } else {
        removeList += [false]
      }
    }

    for (currentIndex, shouldRemove) in enumerate(removeList) {
      if shouldRemove {
        if let index = index {
          screenshotImages.removeAtIndex(index)
        }
      }
    }
    return super.popToViewController(viewController, animated: animated)
  }

  override public func setViewControllers(viewControllers: [AnyObject]!, animated: Bool) {
    super.setViewControllers(viewControllers, animated: animated)
    for (currentIndex, viewController) in enumerate(viewControllers) {
      if currentIndex == viewControllers.endIndex {
        break
      }

      if let viewController = viewController as? UIViewController {
        if let image = viewController.screenshotFromWindow(scale: SAHistoryNavigationViewController.kImageScale) {
          screenshotImages += [image]
        }
      }
    }
  }
}

extension SAHistoryNavigationViewController: UINavigationBarDelegate {
  public func navigationBar(navigationBar: UINavigationBar, didPopItem item: UINavigationItem) {
    screenshotImages.removeLast()
  }
}

extension SAHistoryNavigationViewController {
  override public func showHistory() {
    super.showHistory()

    if let image = visibleViewController.screenshotFromWindow(scale: SAHistoryNavigationViewController.kImageScale) {
      screenshotImages += [image]
    }

    historyViewController.images = screenshotImages
    historyViewController.currentIndex = viewControllers.count - 1
    historyViewController.reload()
    historyViewController.view.alpha = 1.0

    coverView.hidden = false
    historyContentView.hidden = false

    setNavigationBarHidden(true, animated: false)
    UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseOut, animations: {
      self.historyViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.7, 0.7)
      }) { _ in }
  }

  override public func setHistoryBackgroundColor(color: UIColor) {
    coverView.backgroundColor = color
  }

  override public func contentView() -> UIView? {
    return historyContentView
  }

  func detectLongTap(gesture: UILongPressGestureRecognizer) {
    if gesture.state == .Began {
      showHistory()
    }
  }

  func popGestureRecognized(gesture: UIGestureRecognizer) {
    println("\(gesture.locationInView(gesture.view).x) \(gesture.view?.bounds.width) \(gesture.state.rawValue)")
    if gesture.state == .Began {
      isSwiping = true
    } else if gesture.state == .Ended {
      isSwiping = false
    }
    //    if gesture.state == .Ended {
    //      screenshotImages.removeLast()
    //    }
    //    200 going not
    //    209 going
  }
}

extension SAHistoryNavigationViewController: SAHistoryViewControllerDelegate {
  func didSelectIndex(index: Int) {

    if let viewControllers = self.viewControllers as? [UIViewController] {
      var destinationViewController: UIViewController?
      for (currentIndex, viewController) in enumerate(viewControllers) {
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
        }) { (finished) in
          self.coverView.hidden = true
          self.historyContentView.hidden = true
          self.historyViewController.view.alpha = 0.0
          self.setNavigationBarHidden(false, animated: false)
      }
    }
  }
}

extension SAHistoryNavigationViewController: UIGestureRecognizerDelegate {
  public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
    if let backItem = visibleViewController.navigationController?.navigationBar.backItem {
      var height = 64.0
      if visibleViewController.navigationController?.navigationBarHidden == true {
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

extension SAHistoryNavigationViewController: UINavigationControllerDelegate {
  public func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
    _navigationDelegate?.navigationController?(self, willShowViewController: viewController, animated: animated)
  }
  public func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
    _navigationDelegate?.navigationController?(self, didShowViewController: viewController, animated: animated)
  }

  public func navigationControllerSupportedInterfaceOrientations(navigationController: UINavigationController) -> Int {
    if let supportedInterfaceOrientations = _navigationDelegate?.navigationControllerSupportedInterfaceOrientations?(self) {
      return supportedInterfaceOrientations
    }
    return UIInterfaceOrientation.Unknown.rawValue
  }

  public func navigationControllerPreferredInterfaceOrientationForPresentation(navigationController: UINavigationController) -> UIInterfaceOrientation {
    if let preferredInterfaceOrientationForPresentation = _navigationDelegate?.navigationControllerPreferredInterfaceOrientationForPresentation?(self) {
      return preferredInterfaceOrientationForPresentation
    }
    return .Unknown
  }

}
