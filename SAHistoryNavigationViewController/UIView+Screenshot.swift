//
//  UIView+Screenshot.swift
//  SAHistoryNavigationViewController
//
//  Created by 鈴木大貴 on 2015/01/12.
//  Copyright (c) 2015年 鈴木大貴. All rights reserved.
//

import UIKit

extension SAHistoryExtension where Base: UIView {
    func screenshotImage(_ scale: CGFloat = 0.0) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(base.frame.size, false, scale)
        base.drawHierarchy(in: base.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
