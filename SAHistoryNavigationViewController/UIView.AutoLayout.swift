//
//  UIView.AutoLayout.swift
//  SAHistoryNavigationViewController
//
//  Created by marty-suzuki on 2017/11/01.
//

import UIKit

extension UIView {
    struct Layout {
        static func top(multiplier: CGFloat = 1, constant: CGFloat = 0) -> Layout {
            return Layout(attribute: .top, multiplier: multiplier, constant: constant)
        }
        static func left(multiplier: CGFloat = 1, constant: CGFloat = 0) -> Layout {
            return Layout(attribute: .left, multiplier: multiplier, constant: constant)
        }
        static func right(multiplier: CGFloat = 1, constant: CGFloat = 0) -> Layout {
            return Layout(attribute: .right, multiplier: multiplier, constant: constant)
        }
        static func bottom(multiplier: CGFloat = 1, constant: CGFloat = 0) -> Layout {
            return Layout(attribute: .bottom, multiplier: multiplier, constant: constant)
        }
        static func centerX(multiplier: CGFloat = 1, constant: CGFloat = 0) -> Layout {
            return Layout(attribute: .centerX, multiplier: multiplier, constant: constant)
        }
        static func width(multiplier: CGFloat = 1, constant: CGFloat = 0) -> Layout {
            return Layout(attribute: .width, multiplier: multiplier, constant: constant)
        }
        
        let attribute: NSLayoutAttribute
        let multiplier: CGFloat
        let constant: CGFloat
        
        init(attribute: NSLayoutAttribute, multiplier: CGFloat = 1, constant: CGFloat = 0) {
            self.attribute = attribute
            self.multiplier = multiplier
            self.constant = constant
        }
    }
    
    func addSubview(_ subview: UIView, to layouts: [Layout]) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(layouts.map {
            .init(item: subview,
                  attribute: $0.attribute,
                  relatedBy: .equal,
                  toItem: self,
                  attribute: $0.attribute,
                  multiplier: $0.multiplier,
                  constant: $0.constant)
        })
    }
}
