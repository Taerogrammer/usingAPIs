//
//  UIColor+Extension.swift
//  0117_Networks
//
//  Created by 김태형 on 1/23/25.
//

import UIKit

extension UIColor {
    static var defaultBackgroundColor: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .light {
                    return .white
                } else {
                    return .black
                }
            }
        } else {
            return .white
        }
    }
    static var defaultTextColor: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .light {
                    return .black
                } else {
                    return .white
                }
            }
        } else {
            return .black
        }
    }

}
