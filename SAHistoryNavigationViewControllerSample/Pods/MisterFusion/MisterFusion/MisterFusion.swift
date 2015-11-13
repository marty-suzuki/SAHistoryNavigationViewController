//
//  MisterFusion.swift
//  MisterFusion
//
//  Created by Taiki Suzuki on 2015/11/13.
//  Copyright © 2015年 Taiki Suzuki. All rights reserved.
//

import UIKit

public struct MisterFusion {
    private let item: UIView?
    private let attribute: NSLayoutAttribute?
    private let relatedBy: NSLayoutRelation?
    private let toItem: UIView?
    private let toAttribute: NSLayoutAttribute?
    private let multiplier: CGFloat?
    private let constant: CGFloat?
    private let priority: UILayoutPriority?
}

infix operator |==| { associativity left precedence 100 }
public func |==| (left: MisterFusion, right: MisterFusion) -> MisterFusion {
    return MisterFusion(item: left.item, attribute: left.attribute, relatedBy: .Equal, toItem: right.item, toAttribute: right.attribute, multiplier: nil, constant: nil, priority: nil)
}

infix operator |<=| { associativity left precedence 100 }
public func |<=| (left: MisterFusion, right: MisterFusion) -> MisterFusion {
    return MisterFusion(item: left.item, attribute: left.attribute, relatedBy: .LessThanOrEqual, toItem: right.item, toAttribute: right.attribute, multiplier: nil, constant: nil, priority: nil)
}

infix operator |>=| { associativity left precedence 100 }
public func |>=| (left: MisterFusion, right: MisterFusion) -> MisterFusion {
    return MisterFusion(item: left.item, attribute: left.attribute, relatedBy: .GreaterThanOrEqual, toItem: right.item, toAttribute: right.attribute, multiplier: nil, constant: nil, priority: nil)
}

infix operator |+| { associativity left precedence 100 }
public func |+| (left: MisterFusion, right: CGFloat) -> MisterFusion {
    return MisterFusion(item: left.item, attribute: left.attribute, relatedBy: left.relatedBy, toItem: left.toItem, toAttribute: left.toAttribute, multiplier: left.multiplier, constant: right, priority: left.priority)
}

infix operator |-| { associativity left precedence 100 }
public func |-| (left: MisterFusion, right: CGFloat) -> MisterFusion {
    return MisterFusion(item: left.item, attribute: left.attribute, relatedBy: left.relatedBy, toItem: left.toItem, toAttribute: left.toAttribute, multiplier: left.multiplier, constant: -right, priority: left.priority)
}

infix operator |*| { associativity left precedence 100 }
public func |*| (left: MisterFusion, right: CGFloat) -> MisterFusion {
    return MisterFusion(item: left.item, attribute: left.attribute, relatedBy: left.relatedBy, toItem: left.toItem, toAttribute: left.toAttribute, multiplier: right, constant: left.constant, priority: left.priority)
}

infix operator |/| { associativity left precedence 100 }
public func |/| (left: MisterFusion, right: CGFloat) -> MisterFusion {
    return MisterFusion(item: left.item, attribute: left.attribute, relatedBy: left.relatedBy, toItem: left.toItem, toAttribute: left.toAttribute, multiplier: 1 / right, constant: left.constant, priority: left.priority)
}

infix operator |<>| { associativity left precedence 100 }
public func |<>| (left: MisterFusion, right: UILayoutPriority) -> MisterFusion {
    return MisterFusion(item: left.item, attribute: left.attribute, relatedBy: left.relatedBy, toItem: left.toItem, toAttribute: left.toAttribute, multiplier: left.multiplier, constant: left.constant, priority: right)
}

extension UIView {
    public var Top: MisterFusion { return createMisterFusion(.Top) }
    
    public var Right: MisterFusion { return createMisterFusion(.Right) }
    
    public var Left: MisterFusion { return createMisterFusion(.Left) }
    
    public var Bottom: MisterFusion { return createMisterFusion(.Bottom) }
    
    public var Height: MisterFusion { return createMisterFusion(.Height) }
    
    public var Width: MisterFusion { return createMisterFusion(.Width) }
    
    public var Leading: MisterFusion { return createMisterFusion(.Leading) }
    
    public var Trailing: MisterFusion { return createMisterFusion(.Trailing) }
    
    public var CenterX: MisterFusion { return createMisterFusion(.CenterX) }
    
    public var CenterY: MisterFusion { return createMisterFusion(.CenterY) }
    
    public var Baseline: MisterFusion { return createMisterFusion(.Baseline) }
    
    public var LastBaseline: MisterFusion { return createMisterFusion(.LastBaseline) }
    
    public var NotAnAttribute: MisterFusion { return createMisterFusion(.NotAnAttribute) }
    
    @available(iOS 8.0, *)
    public var LeftMargin: MisterFusion { return createMisterFusion(.LeftMargin) }
    
    @available(iOS 8.0, *)
    public var RightMargin: MisterFusion { return createMisterFusion(.RightMargin) }
    
    @available(iOS 8.0, *)
    public var TopMargin: MisterFusion { return createMisterFusion(.TopMargin) }
    
    @available(iOS 8.0, *)
    public var BottomMargin: MisterFusion { return createMisterFusion(.BottomMargin) }
    
    @available(iOS 8.0, *)
    public var LeadingMargin: MisterFusion { return createMisterFusion(.LeadingMargin) }
    
    @available(iOS 8.0, *)
    public var TrailingMargin: MisterFusion { return createMisterFusion(.TrailingMargin) }
    
    @available(iOS 8.0, *)
    public var CenterXWithinMargins: MisterFusion { return createMisterFusion(.CenterXWithinMargins) }
    
    @available(iOS 8.0, *)
    public var CenterYWithinMargins: MisterFusion { return createMisterFusion(.CenterYWithinMargins) }
    
    private func createMisterFusion(attribute: NSLayoutAttribute) -> MisterFusion {
        return MisterFusion(item: self, attribute: attribute, relatedBy: nil, toItem: nil, toAttribute: nil, multiplier: nil, constant: nil, priority: nil)
    }
    
    public func addConstraint(misterFusion: MisterFusion) -> NSLayoutConstraint {
        let item: UIView = misterFusion.item ?? self
        let attribute: NSLayoutAttribute = misterFusion.attribute ?? .NotAnAttribute
        let relatedBy: NSLayoutRelation = misterFusion.relatedBy ?? .Equal
        let toItem: UIView = misterFusion.toItem ?? self
        let toAttribute: NSLayoutAttribute = misterFusion.toAttribute ?? attribute
        let multiplier: CGFloat = misterFusion.multiplier ?? 1
        let constant: CGFloat = misterFusion.constant ?? 0
        let constraint = NSLayoutConstraint(item: item, attribute: attribute, relatedBy: relatedBy, toItem: toItem, attribute: toAttribute, multiplier: multiplier, constant: constant)
        constraint.priority = misterFusion.priority ?? UILayoutPriorityRequired
        addConstraint(constraint)
        return constraint
    }
    
    public func addConstraints(misterFusions: MisterFusion...) -> [NSLayoutConstraint] {
        return misterFusions.map { addConstraint($0) }
    }
}