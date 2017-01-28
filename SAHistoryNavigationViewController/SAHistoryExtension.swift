//
//  SAHistoryExtension.swift
//  SAHistoryNavigationViewController
//
//  Created by 鈴木大貴 on 2017/01/28.
//  Copyright (c) 2015年 鈴木大貴. All rights reserved.
//

import UIKit

public protocol SAHistoryCompatible {
    associatedtype CompatibleType
    var sah: CompatibleType { get }
}

public extension SAHistoryCompatible {
    public var sah: SAHistoryExtension<Self> {
        return SAHistoryExtension(self)
    }
}

public final class SAHistoryExtension<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

extension UIViewController: SAHistoryCompatible {}

extension SAHistoryExtension where Base: UIViewController {
    public var navigationController: SAHistoryNavigationViewController? {
        return base.navigationController as? SAHistoryNavigationViewController
    }
}
