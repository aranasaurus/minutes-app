//
//  Colors.swift
//  Minutes
//
//  Created by Ryan Arana on 10/30/16.
//  Copyright © 2016 Aranasaurus. All rights reserved.
//

import UIKit

struct Colors {
    struct Color {
        let base: UIColor
        let light: UIColor
        let dark: UIColor
        let subdued: UIColor
        let highlighted: UIColor
        let actionable: UIColor

        init(base: UIColor,
             light: UIColor? = nil,
             dark: UIColor? = nil,
             subdued: UIColor? = nil,
             highlighted: UIColor? = nil,
             actionable: UIColor? = nil
            ) {
            self.base = base
            self.light = light ?? base
            self.dark = dark ?? base
            self.subdued = subdued ?? base.withAlphaComponent(0.33)
            self.highlighted = highlighted ?? base
            self.actionable = actionable ?? highlighted ?? base
        }

        init(_ base: UIColor) {
            self.init(base: base)
        }
    }
}

// Green theme
//extension Colors {
//    private static let hue = CGFloat(149.0/360.0)
//    private static let sat = CGFloat(1)
//    private static let bri = CGFloat(0.6)
//
//    static let primary = Color(
//        base: UIColor(hue: hue, saturation: sat, brightness: bri, alpha: 1),
//        light: UIColor(hue: hue, saturation: sat/3, brightness: 1, alpha: 1),
//        dark: UIColor(hue: hue, saturation: min(1, sat*1.2), brightness: 0.33, alpha: 1),
//        actionable: UIColor(hue: hue, saturation: 0.04, brightness: 1, alpha: 1)
//    )
//
//    static let contrast = Color(
//        UIColor(
//            hue: hue <= 0.5 ? hue + 0.5 : (hue + 0.5).remainder(dividingBy: 1),
//            saturation: sat,
//            brightness: 1,
//            alpha: 1
//        )
//    )
//
//    static let background = Color(
//        base: UIColor(hue: hue, saturation: 0.00, brightness: 0.7, alpha: 1),
//        light: UIColor(hue: hue, saturation: sat * 0.005, brightness: 0.97, alpha: 1),
//        dark: UIColor(hue: hue, saturation: sat * 0.25, brightness: 0.5, alpha: 1),
//        highlighted: UIColor(hue: hue, saturation: 0.005, brightness: 1, alpha: 1)
//    )
//
//    static let negative = Color(.red)
//    static let positive = Color(.green)
//}

// Blue and Pink theme
//extension Colors {
//    static let background = Color(
//        base: UIColor(hue: 205.0/360.0, saturation: 0.03, brightness: 0.9, alpha: 1),
//        dark: UIColor(hue: 306.0/360.0, saturation: 0.23, brightness: 0.17, alpha: 1),
//        highlighted: UIColor(hue: 338.0/360.0, saturation: 0.03, brightness: 1, alpha: 1)
//    )
//
//    static let primary = Color(
//        base: UIColor(hue: 205.0/360.0, saturation: 0.92, brightness: 0.7, alpha: 1),
//        light: UIColor(hue: 205.0/360.0, saturation: 0.89, brightness: 1, alpha: 1),
//        dark: UIColor(hue: 213.0/360.0, saturation: 0.77, brightness: 0.59, alpha: 1)
//    )
//
//    static let contrast = Color(
//        base: UIColor(hue: 338.0/360.0, saturation: 0.77, brightness: 1, alpha: 1)
//    )
//
//    static let negative = Color(#colorLiteral(red: 1, green: 0.499999995, blue: 0.1428571343, alpha: 1))
//    static let positive = Color(#colorLiteral(red: 0.3838160634, green: 0.704803288, blue: 0.1228413507, alpha: 1))
//    static let actionable = Color(#colorLiteral(red: 0.9450980392, green: 0.9490196078, blue: 0.9215686275, alpha: 1))
//}

// Turquoise
extension Colors {
    private static let hue = CGFloat(190.0/360.0)
    private static let sat = CGFloat(0.8)
    private static let bri = CGFloat(0.77)

    static let primary = Color(
        base: UIColor(hue: hue, saturation: sat, brightness: bri, alpha: 1),
        light: UIColor(hue: hue, saturation: sat/3, brightness: 1, alpha: 1),
        dark: UIColor(hue: hue, saturation: min(1, sat*1.2), brightness: 0.33, alpha: 1),
        actionable: UIColor(hue: hue, saturation: 0.04, brightness: 1, alpha: 1)
    )

    static let contrast = Color(
        UIColor(
            hue: hue.shifted(by: 0.3667),
            saturation: sat * 0.9,
            brightness: bri * 1.2,
            alpha: 1
        )
    )

    static let background = Color(
        base: UIColor(hue: hue, saturation: 0.00, brightness: 0.7, alpha: 1),
        light: UIColor(hue: hue.shifted(by: 0.6667), saturation: sat * 0.04, brightness: 0.98, alpha: 1),
        dark: UIColor(hue: hue.shifted(by: 0.6667), saturation: sat * 0.125, brightness: 0.333, alpha: 1),
        highlighted: UIColor(hue: hue, saturation: 0.005, brightness: 1, alpha: 1)
    )

    static let negative = Color(.red)
    static let positive = Color(.green)
}

// Testbed
//extension Colors {
//    private static let hue = CGFloat(190.0/360.0)
//    private static let sat = CGFloat(0.8)
//    private static let bri = CGFloat(0.77)
//
//    static let primary = Color(
//        base: UIColor(hue: hue, saturation: sat, brightness: bri, alpha: 1),
//        light: UIColor(hue: hue, saturation: sat/3, brightness: 1, alpha: 1),
//        dark: UIColor(hue: hue, saturation: min(1, sat*1.2), brightness: 0.33, alpha: 1),
//        actionable: UIColor(hue: hue, saturation: 0.04, brightness: 1, alpha: 1)
//    )
//
//    static let contrast = Color(
//        UIColor(
//            hue: hue.shifted(by: 0.3667),
//            saturation: sat * 0.9,
//            brightness: bri * 1.2,
//            alpha: 1
//        )
//    )
//
//    static let background = Color(
//        base: UIColor(hue: hue, saturation: 0.00, brightness: 0.7, alpha: 1),
//        light: UIColor(hue: hue.shifted(by: 0.6667), saturation: sat * 0.04, brightness: 0.98, alpha: 1),
//        dark: UIColor(hue: hue.shifted(by: 0.6667), saturation: sat * 0.125, brightness: 0.333, alpha: 1),
//        highlighted: UIColor(hue: hue, saturation: 0.005, brightness: 1, alpha: 1)
//    )
//
//    static let negative = Color(.red)
//    static let positive = Color(.green)
//}

extension CGFloat {
    func shifted(by amount: CGFloat = 0.5, around: CGFloat = 1) -> CGFloat {
        let result = self <= around - amount ? self + amount : abs((self + amount).remainder(dividingBy: around))
//        print("shifting \(self)[\(self * 360)] by \(amount): \(result)[\(result * 360)]")
        return result
    }
}
