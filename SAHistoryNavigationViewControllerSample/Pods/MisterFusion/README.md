# MisterFusion

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![Version](https://img.shields.io/cocoapods/v/MisterFusion.svg?style=flat)](http://cocoapods.org/pods/MisterFusion)
[![License](https://img.shields.io/cocoapods/l/MisterFusion.svg?style=flat)](http://cocoapods.org/pods/MisterFusion)

![](./logo.png)

MisterFusion makes more easier and swifty to use AutoLayout in code.

#### MisterFusion Code

```swift
let view = UIView()
self.view.addSubview(view)
self.view.translatesAutoresizingMaskIntoConstraints = false
self.view.addConstraints(
    view.Top    |+| 10,
    view.Right  |-| 10,
    view.Left   |+| 10,
    view.Bottom |-| 10
)
```

#### Ordinary Code

This is same implementation as above code, but this is hard to see.

```swift
let view = UIView()
self.view.addSubview(view)
self.view.translatesAutoresizingMaskIntoConstraints = false
self.view.addConstraints([
    NSLayoutConstraint(item: view, attribute: .Top,    relatedBy: .Equal, toItem: self.view, attribute: .Top,    multiplier: 1, constant:  10),
    NSLayoutConstraint(item: view, attribute: .Right,  relatedBy: .Equal, toItem: self.view, attribute: .Right,  multiplier: 1, constant: -10),
    NSLayoutConstraint(item: view, attribute: .Left,   relatedBy: .Equal, toItem: self.view, attribute: .Left,   multiplier: 1, constant:  10),
    NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: -10),
])
```

## Installation

#### CocoaPods

MisterFusion is available through [CocoaPods](http://cocoapods.org). If you have cocoapods 0.39.0 or greater, you can install
it, simply add the following line to your Podfile:

	pod "MisterFusion"

## Advanced Setting

You can set `multiplier`, `constant` and `priority` like this.
(This is same implementation as [first example](#misterfusion-code).)

```swift
self.view.addConstraints(
    view.Top    |==| self.view.Top    |*| 1 |+| 10 |<>| UILayoutPriorityRequired,
    view.Right  |==| self.view.Right  |*| 1 |-| 10 |<>| UILayoutPriorityRequired,
    view.Left   |==| self.view.Left   |*| 1 |+| 10 |<>| UILayoutPriorityRequired,
    view.Bottom |==| self.view.Bottom |*| 1 |-| 10 |<>| UILayoutPriorityRequired
)
```

#### Operators

- `|==|`, `|<=|`, `|>=|` ... `NSLayoutRelation`
- `|*|`, `|/|` ... `multiplier`
- `|+|`, `|-|` ... `constant`
- `|<>|` ... `UILayoutPriority`

#### UIView Extensions

```swift
public func addConstraint(misterFusion: MisterFusion) -> NSLayoutConstraint
public func addConstraints(misterFusions: MisterFusion...) -> [NSLayoutConstraint]
```

You can get added `NSLayoutConstraint` like this.

```swift
let bottomConstraint: NSLayoutConstraint = self.view.addConstraints(
    view.Top    |+| 10,
    view.Right  |-| 10,
    view.Left   |+| 10,
    view.Bottom |-| 10
).filter { $0.firstAttribute == .Bottom }.first
```


## Requirements

- Xcode 7.0 or greater
- iOS8.0 or greater

## Author

Taiki Suzuki, s1180183@gmail.com

## License

MisterFusion is available under the MIT license. See the LICENSE file for more info.
