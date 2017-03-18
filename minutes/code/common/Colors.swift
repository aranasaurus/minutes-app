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

        init(base: UIColor,
             light: UIColor? = nil,
             dark: UIColor? = nil,
             subdued: UIColor? = nil,
             highlighted: UIColor? = nil
            ) {
            self.base = base
            self.light = light ?? base
            self.dark = dark ?? base
            self.subdued = subdued ?? base.withAlphaComponent(0.33)
            self.highlighted = highlighted ?? base
        }

        init(_ base: UIColor) {
            self.init(base: base)
        }
    }

    static let background = Color(
        base: UIColor(hue: 205.0/360.0, saturation: 0.03, brightness: 0.9, alpha: 1),
        dark: #colorLiteral(red: 0.2274509804, green: 0.1803921569, blue: 0.2235294118, alpha: 1),
        highlighted: UIColor(hue: 338.0/360.0, saturation: 0.03, brightness: 1, alpha: 1)
    )

    static let primary = Color(
        base: #colorLiteral(red: 0, green: 0.5223739119, blue: 0.7551724138, alpha: 1),
        light: #colorLiteral(red: 0.07664274707, green: 0.7153548233, blue: 1, alpha: 1),
        dark: UIColor(hue: 213.0/360.0, saturation: 0.77, brightness: 0.59, alpha: 1)
    )

    static let contrast = Color(
        base: #colorLiteral(red: 1, green: 0.3334046006, blue: 0.5770114064, alpha: 1)
    )

    static let negative = Color(#colorLiteral(red: 1, green: 0.5000066161, blue: 0.1428571343, alpha: 1))
    static let positive = Color(#colorLiteral(red: 0.3838160634, green: 0.704803288, blue: 0.1228413507, alpha: 1))
    static let actionable = Color(#colorLiteral(red: 0.9450980392, green: 0.9490196078, blue: 0.9215686275, alpha: 1))
}
