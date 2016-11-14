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
    func buttonTapped(at indexPath: IndexPath)
}

class ProjectCell: UICollectionViewCell {
    static let reuseIdentifier = "ProjectCell"

    let imgView: UIImageView
    let nameLabel: UILabel
    let timeLabel: UILabel
    let priceLabel: UILabel
    let startButton: UIButton

    weak var delegate: ProjectCellDelegate?
    var indexPath: IndexPath!
    var timer: Timer?

    override init(frame: CGRect) {
        imgView = UIImageView(frame: .zero)
        nameLabel = UILabel(frame: .zero)
        timeLabel = UILabel(frame: .zero)
        priceLabel = UILabel(frame: .zero)
        startButton = UIButton(type: .system)

        super.init(frame: frame)

        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = Colors.primary.cgColor
        contentView.layer.borderWidth = 1
        contentView.backgroundColor = Colors.lightBackground

        contentView.addSubview(nameLabel)
        timeLabel.textAlignment = .center
        timeLabel.textColor = Colors.primary
        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 22, weight: 2)
        contentView.addSubview(timeLabel)

        startButton.backgroundColor = Colors.primary
        startButton.tintColor = Colors.tint
        startButton.setTitle("Start", for: .normal)
        startButton.layer.cornerRadius = 8
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 28)
        startButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        contentView.addSubview(startButton)
        constrain(nameLabel, timeLabel, startButton, contentView) { name, time, button, container in
            name.top == container.topMargin
            name.leading == container.leadingMargin
            name.trailing == button.leading - 8

            button.top == container.topMargin + 2
            button.height == container.height * 0.6
            button.width == container.width / 3
            button.trailing == container.trailingMargin - 2

            time.top == button.bottom + 8
            time.leading == button.leading
            time.trailing == button.trailing
            time.bottom == container.bottomMargin - 2
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func buttonTapped() {
        delegate?.buttonTapped(at: indexPath)
    }

    func configure(with project: Project, at indexPath: IndexPath? = nil, delegate: ProjectCellDelegate?) {
        self.delegate = delegate
        self.indexPath = indexPath ?? self.indexPath
        nameLabel.text = project.name
        timeLabel.text = delegate?.durationFormatter.string(from: project.totalTime)

        if project.isTracking {
            timer?.invalidate()
            timer = Timer(timeInterval: 1, repeats: true) { _ in
                self.timeLabel.text = self.delegate?.durationFormatter.string(from: project.totalTime)
            }
            RunLoop.current.add(timer!, forMode: .commonModes)

            startButton.setTitle("Stop", for: .normal)
            startButton.backgroundColor = Colors.contrast
            contentView.layer.borderColor = Colors.contrast.cgColor
            contentView.layer.borderWidth = 2
            timeLabel.textColor = Colors.contrast
        } else {
            timer?.invalidate()
            timer = nil

            startButton.setTitle("Start", for: .normal)
            startButton.backgroundColor = Colors.primary
            contentView.layer.borderColor = Colors.primary.cgColor
            contentView.layer.borderWidth = 1
            timeLabel.textColor = Colors.primary
        }
    }
}
