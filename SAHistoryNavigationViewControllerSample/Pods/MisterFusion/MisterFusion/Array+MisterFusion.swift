//
//  Array+NSLayoutConstraint.swift
//  MisterFusion
//
//  Created by Taiki Suzuki on 2015/11/18.
//  Copyright © 2015年 Taiki Suzuki. All rights reserved.
//

import UIKit

extension Array where Element: NSLayoutConstraint {
    public func firstItem(_ view: UIView) -> [Element] {
        return filter { $0.firstItem as? UIView == view }
    }
    
    public func firstAttribute(_ attribute: NSLayoutAttribute) -> [Element] {
        return filter { $0.firstAttribute == attribute }
    }
    
    public func relation(_ relation: NSLayoutRelation) -> [Element] {
        return filter { $0.relation == relation }
    }
    
    public func secondItem(_ view: UIView) -> [Element] {
        return filter { $0.secondItem as? UIView == view }
    }
    
    public func secondAttribute(_ attribute: NSLayoutAttribute) -> [Element] {
        return filter { $0.secondAttribute == attribute }
    }
}

extension NSArray {
    @available(*, unavailable)
    @objc(FirstItem)
    public var firstItem: (UIView) -> NSArray {
        guard let array = self as? [NSLayoutConstraint] else {
            return { _ in return [] }
        }
        return { view in
            return array.filter { $0.firstItem as? UIView == view } as NSArray
        }
    }
    
    @available(*, unavailable)
    @objc(FirstAttribute)
    public var firstAttribute: (NSLayoutAttribute) -> NSArray {
        guard let array = self as? [NSLayoutConstraint] else {
            return { _ in return [] }
        }
        return { attribute in
            return array.filter { $0.firstAttribute == attribute } as NSArray
        }
    }
    
    @available(*, unavailable)
    @objc(SecondItem)
    public var secondItem: (UIView) -> NSArray {
        guard let array = self as? [NSLayoutConstraint] else {
            return { _ in return [] }
        }
        return { view in
            return array.filter { $0.secondItem as? UIView == view } as NSArray
        }
    }
    
    @available(*, unavailable)
    @objc(SecondAttribute)
    public var secondAttribute: (NSLayoutAttribute) -> NSArray {
        guard let array = self as? [NSLayoutConstraint] else {
            return { _ in return [] }
        }
        return { attribute in
            return array.filter { $0.secondAttribute == attribute } as NSArray
        }
    }
    
    @available(*, unavailable)
    @objc(Reration)
    public var reration: (NSLayoutRelation) -> NSArray {
        guard let array = self as? [NSLayoutConstraint] else {
            return { _ in return [] }
        }
        return { relation in
            return array.filter { $0.relation == relation } as NSArray
        }
    }
}
