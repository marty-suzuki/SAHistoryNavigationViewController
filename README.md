# SAHistoryNavigationViewController

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![Version](https://img.shields.io/cocoapods/v/SAHistoryNavigationViewController.svg?style=flat)](http://cocoapods.org/pods/SAHistoryNavigationViewController)
[![License](https://img.shields.io/cocoapods/l/SAHistoryNavigationViewController.svg?style=flat)](http://cocoapods.org/pods/SAHistoryNavigationViewController)

![](./SampleImage/sample.gif)

SAHistoryNavigationViewController realizes iOS task manager like UI in UINavigationContoller.

## Features

- [x] iOS task manager like UI
- [x] Launch Navigation History with Long tap action of Back Bar Button

## Installation

#### CocoaPods

SAHistoryNavigationViewController is available through [CocoaPods](http://cocoapods.org). If you have cocoapods 0.36.0 or greater, you can install
it, simply add the following line to your Podfile:

    pod "SAHistoryNavigationViewController"

#### Manually

Add the [SAHistoryNavigationViewController](./SAHistoryNavigationViewController) directory to your project. 

## Usage

If you install from cocoapods, You have to write `import SAHistoryNavigationViewController`.


#### Storyboard or Xib
![](./SampleImage/storyboard.png)

Set custom class of UINavigationController to SAHistoryNavigationViewController.
In addition, set module to SAHistoryNavigationViewController.

#### Code

You can use SAHistoryNavigationViewController as `self.navigationController` in ViewController, bacause implemented `extension UINavigationController` as below codes and override those methods in SAHistoryNavigationViewController.

```swift
extension UINavigationController {
    public weak var navigationDelegate: SAHistoryNavigationViewControllerDelegate? {
        set {
            willSetNavigationDelegate(navigationDelegate)
        }
        get {
            return willGetNavigationDelegate()
        }
    }
    public weak var transitionDelegate: SAHistoryNavigationViewControllerTransitionDelegate? {
        set {
            willSetTransitionDelegate(transitionDelegate)
        }
        get {
            return willGetTransitionDelegate()
        }
    }
    public func showHistory() {}
    public func setHistoryBackgroundColor(color: UIColor) {}
    public func contentView() -> UIView? { return nil }
    func willSetNavigationDelegate(navigationDelegate: SAHistoryNavigationViewControllerDelegate?) {}
    func willGetNavigationDelegate() -> SAHistoryNavigationViewControllerDelegate? { return nil }
    func willSetTransitionDelegate(transitionDelegate: SAHistoryNavigationViewControllerTransitionDelegate?) {}
    func willGetTransitionDelegate() -> SAHistoryNavigationViewControllerTransitionDelegate? { return nil }
}
```

And you have to initialize like this.


```swift
	let ViewController = UIViewController()
	let navigationController = SAHistoryNavigationViewController()
	navigationController.setViewControllers([ViewController], animated: true)
	presentViewController(navigationController, animated: true, completion: nil)
```

If you want to launch Navigation History without long tap action, use this code.

```swift
	navigationController?.showHistory()
```

## Customize

If you want to customize background of Navigation History, you can use those methods.

```swift
	navigationController?.contentView()
	navigationController?.setHistoryBackgroundColor(color: UIColor)
```

This is delegate methods.

```swift
@objc public protocol SAHistoryNavigationViewControllerDelegate : NSObjectProtocol {
    optional func navigationController(navigationController: SAHistoryNavigationViewController, willShowViewController viewController: UIViewController, animated: Bool)
    optional func navigationController(navigationController: SAHistoryNavigationViewController, didShowViewController viewController: UIViewController, animated: Bool)
    optional func navigationControllerSupportedInterfaceOrientations(navigationController: SAHistoryNavigationViewController) -> Int
    optional func navigationControllerPreferredInterfaceOrientationForPresentation(navigationController: SAHistoryNavigationViewController) -> UIInterfaceOrientation
}
```

```swift
@objc public protocol SAHistoryNavigationViewControllerTransitionDelegate : NSObjectProtocol {
    optional func navigationController(navigationController: SAHistoryNavigationViewController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
    optional func navigationController(navigationController: SAHistoryNavigationViewController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
}
```

## Requirements

- Xcode 6.3 or greater
- iOS7.0(manually only) or greater

## Author

Taiki Suzuki, s1180183@gmail.com

## License

SAHistoryNavigationViewController is available under the MIT license. See the LICENSE file for more info.
