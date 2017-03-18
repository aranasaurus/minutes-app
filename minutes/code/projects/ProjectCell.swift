//
//  ProjectCell.swift
//  Minutes
//
//  Created by Ryan Arana on 10/30/16.
//  Copyright © 2016 Aranasaurus. All rights reserved.
//

import UIKit
import Cartography

protocol ProjectCellDelegate: class {
    var durationFormatter: DateComponentsFormatter { get }
    var priceFormatter: NumberFormatter { get }
    func buttonTapped(at indexPath: IndexPath)
}

class ProjectCell: UICollectionViewCell {
    static let reuseIdentifier = "ProjectCell"

    let nameLabel: UILabel
    let timeLabel: UILabel
    let priceLabel: UILabel
    let startButton: UIButton

    weak var delegate: ProjectCellDelegate?
    var indexPath: IndexPath!
    var timer: Timer?
    var project: Project?

    private let nameFont: UIFont
    private let nameWeight: CGFloat = 0.33
    private let timeFont: UIFont
    private let timeWeight: CGFloat = 0.33
    private let priceFont: UIFont
    private let priceWeight: CGFloat = 0.5

    override var isHighlighted: Bool {
        willSet {
            updateColors(highlighted: newValue)
        }
    }

    override var isSelected: Bool {
        willSet {
            updateColors(selected: newValue)
        }
    }

    override init(frame: CGRect) {
        nameLabel = UILabel(frame: .zero)
        timeLabel = UILabel(frame: .zero)
        priceLabel = UILabel(frame: .zero)
        startButton = UIButton(type: .system)

        let size = UIFont.preferredFont(forTextStyle: .title1).pointSize
        nameFont = UIFont.systemFont(ofSize: size, weight: nameWeight)
        priceFont = UIFont.monospacedDigitSystemFont(ofSize: size * 1.25, weight: priceWeight)
        timeFont = UIFont.monospacedDigitSystemFont(ofSize: size, weight: timeWeight)

        super.init(frame: frame)

        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1

        nameLabel.font = nameFont
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.numberOfLines = 2
        nameLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        contentView.addSubview(nameLabel)

        priceLabel.font = priceFont
        contentView.addSubview(priceLabel)

        timeLabel.textAlignment = .center
        timeLabel.font = timeFont
        contentView.addSubview(timeLabel)

        startButton.setTitle("Start", for: .normal)
        startButton.layer.cornerRadius = 8
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 26)
        startButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        contentView.addSubview(startButton)

        constrain(nameLabel, priceLabel, timeLabel, startButton, contentView) { name, price, time, button, container in
            name.top == container.topMargin
            name.leading == container.leadingMargin + 8
            name.trailing == button.leading - 8
            name.bottom <= button.bottom

            price.firstBaseline == time.firstBaseline
            price.bottom == time.bottom
            price.leading == name.leading + 4
            price.trailing == container.centerXWithinMargins - 4

            button.top == container.topMargin + 2
            button.bottom == container.centerYWithinMargins - 2
            button.width == container.width * 0.333
            button.trailing == container.trailingMargin - 2

            time.top == container.centerYWithinMargins + 2
            time.bottom == container.bottomMargin
            time.leading == button.leading
            time.trailing == button.trailing
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func buttonTapped() {
        delegate?.buttonTapped(at: indexPath)
    }

    func configure(with project: Project, at indexPath: IndexPath? = nil, delegate: ProjectCellDelegate?) {
        self.project = project
        self.delegate = delegate
        self.indexPath = indexPath ?? self.indexPath
        updateColors()
        nameLabel.text = project.name
        timeLabel.text = delegate?.durationFormatter.string(from: project.totalTime)
        priceLabel.text = delegate?.priceFormatter.string(from: NSNumber(value: -project.cost))

        if project.isTracking {
            timer?.invalidate()
            timer = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
                self?.timeLabel.text = self?.delegate?.durationFormatter.string(from: project.totalTime)
                self?.priceLabel.text = self?.delegate?.priceFormatter.string(from: NSNumber(value: -project.cost))
                self?.updateColors()
            }
            RunLoop.current.add(timer!, forMode: .commonModes)

            startButton.setTitle("Stop", for: .normal)
        } else {
            timer?.invalidate()
            timer = nil

            startButton.setTitle("Start", for: .normal)
            nameLabel.font = nameFont
            timeLabel.font = timeFont
        }
    }

    func updateColors(highlighted: Bool? = nil, selected: Bool? = nil) {
        let highlighted = highlighted ?? isHighlighted
        let selected = selected ?? isSelected

        startButton.tintColor = Colors.actionable.base

        guard let project = self.project else {
            priceLabel.textColor = .clear
            return
        }

        switch project.cost {
        case 0.01...DBL_MAX:
            priceLabel.textColor = Colors.negative.base
        case -DBL_MAX ... -0.01:
            priceLabel.textColor = Colors.positive.base
        default:
            priceLabel.textColor = .clear
        }

        guard highlighted || selected || project.isTracking else {
            contentView.layer.borderColor = Colors.primary.dark.cgColor
            contentView.layer.borderWidth = 2
            contentView.backgroundColor = Colors.background.light

            startButton.backgroundColor = Colors.primary.base
            nameLabel.textColor = Colors.primary.base
            timeLabel.textColor = Colors.primary.subdued
            return
        }

        contentView.layer.borderWidth = 4
        contentView.layer.borderColor = Colors.primary.highlighted.cgColor

        guard project.isTracking else { return }

        contentView.layer.borderColor = Colors.contrast.base.cgColor
        contentView.backgroundColor = Colors.background.highlighted
        startButton.backgroundColor = Colors.contrast.base
        nameLabel.textColor = Colors.contrast.highlighted
        timeLabel.textColor = Colors.contrast.subdued
    }
}
