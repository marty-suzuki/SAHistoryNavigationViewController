//
//  Array+NSLayoutConstraint.swift
//  MisterFusion
//
//  Created by Taiki Suzuki on 2015/11/18.
//  Copyright © 2015年 Taiki Suzuki. All rights reserved.
//

import UIKit

extension Array where Element: NSLayoutConstraint {
    public func firstItem(view: UIView) -> [NSLayoutConstraint] {
        return filter { $0.firstItem as? UIView == view }
    }
    
    public func firstAttribute(attribute: NSLayoutAttribute) -> [NSLayoutConstraint] {
        return filter { $0.firstAttribute == attribute }
    }
    
    public func relation(relation: NSLayoutRelation) -> [NSLayoutConstraint] {
        return filter { $0.relation == relation }
    }
    
    public func secondItem(view: UIView) -> [NSLayoutConstraint] {
        return filter { $0.secondItem as? UIView == view }
    }
    
    public func secondAttribute(attribute: NSLayoutAttribute) -> [NSLayoutConstraint] {
        return filter { $0.secondAttribute == attribute }
    }
}

extension NSArray {
    @available(*, unavailable)
    public var FirstItem: UIView -> NSArray {
        guard let array = self as? [NSLayoutConstraint] else {
            return { _ in return [] }
        }
        return { view in
            return array.filter { $0.firstItem as? UIView == view }
        }
    }
    
    @available(*, unavailable)
    public var FirstAttribute: NSLayoutAttribute -> NSArray {
        guard let array = self as? [NSLayoutConstraint] else {
            return { _ in return [] }
        }
        return { attribute in
            return array.filter { $0.firstAttribute == attribute }
        }
    }
    
    @available(*, unavailable)
    public var SecondItem: UIView -> NSArray {
        guard let array = self as? [NSLayoutConstraint] else {
            return { _ in return [] }
        }
        return { view in
            return array.filter { $0.secondItem as? UIView == view }
        }
    }
    
    @available(*, unavailable)
    public var SecondAttribute: NSLayoutAttribute -> NSArray {
        guard let array = self as? [NSLayoutConstraint] else {
            return { _ in return [] }
        }
        return { attribute in
            return array.filter { $0.secondAttribute == attribute }
        }
    }
    
    @available(*, unavailable)
    public var Reration: NSLayoutRelation -> NSArray {
        guard let array = self as? [NSLayoutConstraint] else {
            return { _ in return [] }
        }
        return { relation in
            return array.filter { $0.relation == relation }
        }
    }
}