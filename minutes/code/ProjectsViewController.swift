//
//  ProjectsViewController.swift
//  Minutes
//
//  Created by Ryan Arana on 10/29/16.
//  Copyright © 2016 Aranasaurus. All rights reserved.
//

import UIKit
import Cartography

final class ProjectsViewController: UIViewController {
    var tableView: UITableView
    var globalTimeLabel: UILabel
    var labelHeight: CGFloat = 52
    var startStopButton: UIButton

    var tracker: Tracker!
    let formatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.hour, .minute, .second]
        f.zeroFormattingBehavior = .pad
        return f
    }()

    init() {
        self.tableView = UITableView(frame: .zero, style: .plain)
        self.globalTimeLabel = UILabel(frame: .zero)
        self.startStopButton = UIButton(type: .system)

        super.init(nibName: nil, bundle: nil)
        self.tracker = Tracker() { newValue, oldValue in
            self.globalTimeLabel.text = self.formatter.string(from: newValue)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lightGray

        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: UIApplication.shared.statusBarFrame.height, left: 0, bottom: labelHeight + 4, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -tableView.contentInset.top)
        view.addSubview(tableView)

        globalTimeLabel.text = "0:00:00"
        globalTimeLabel.font = UIFont.systemFont(ofSize: labelHeight/1.8, weight: UIFontWeightLight)
        globalTimeLabel.textColor = .white
        globalTimeLabel.backgroundColor = .green
        globalTimeLabel.alpha = 0.8
        globalTimeLabel.textAlignment = .center
        view.addSubview(globalTimeLabel)

        startStopButton.titleLabel?.font = UIFont.systemFont(ofSize: 96, weight: UIFontWeightSemibold)
        startStopButton.contentVerticalAlignment = .center
        startStopButton.setTitle("Start", for: .normal)
        startStopButton.backgroundColor = #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)
        startStopButton.tintColor = .white
        startStopButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        view.addSubview(startStopButton)

        constrain(view, tableView, globalTimeLabel, startStopButton) { container, table, label, button in
            table.top == container.topMargin
            table.leading == container.leading
            table.trailing == container.trailing
            table.bottom == button.top

            label.bottom == button.top
            label.leading == container.leading
            label.trailing == container.trailing
            label.height == labelHeight

            button.bottom == container.bottom
            button.leading == container.leading
            button.trailing == container.trailing
        }
    }

    @objc private func buttonTapped() {
        if startStopButton.titleLabel?.text == "Start" {
            startStopButton.setTitle("Stop", for: .normal)
            tracker.start()
        } else {
            startStopButton.setTitle("Start", for: .normal)
            tracker.stop()
        }
    }

}

extension ProjectsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
