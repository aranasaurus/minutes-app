//
//  ProjectCell.swift
//  Minutes
//
//  Created by Ryan Arana on 10/30/16.
//  Copyright © 2016 Aranasaurus. All rights reserved.
//

import UIKit
import Cartography

class ProjectCell: UICollectionViewCell {
    static let reuseIdentifier = "ProjectCell"
    let nameLabel: UILabel
    let startButton: UIButton

    override init(frame: CGRect) {
        nameLabel = UILabel(frame: .zero)
        startButton = UIButton(type: .system)

        super.init(frame: frame)

        contentView.addSubview(nameLabel)
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = Colors.primary.cgColor
        contentView.layer.borderWidth = 1
        contentView.backgroundColor = Colors.lightBackground

        startButton.backgroundColor = Colors.primary
        startButton.tintColor = Colors.tint
        startButton.setTitle("Start", for: .normal)
        startButton.layer.cornerRadius = 8
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 28)
        contentView.addSubview(startButton)

        constrain(nameLabel, startButton, contentView) { name, button, container in
            name.top == container.topMargin
            name.leading == container.leadingMargin
            name.trailing == container.centerXWithinMargins
            name.bottom == container.bottomMargin

            button.top == container.topMargin + 2
            button.bottom == container.bottomMargin - 2
            button.width == container.width / 4
            button.trailing == container.trailingMargin - 2
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(`for` name: String) {
        //nameLabel.text = name
    }
}
