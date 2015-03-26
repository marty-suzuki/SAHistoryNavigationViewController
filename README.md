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

#### Code

You can use SAHistoryNavigationViewController like UINavigationViewController.

```swift
	let viewControlelr = UIViewController()
	let navigationController = SAHistoryNavigationViewController()
	navigationController.setViewControllers([viewControlelr], animated: true)
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

## Requirements

- Xcode 6.1 or greater
- iOS7.0(manually only) or greater

## Author

Taiki Suzuki, s1180183@gmail.com

## License

SAHistoryNavigationViewController is available under the MIT license. See the LICENSE file for more info.
