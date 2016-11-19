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
    var statusBarBackground: UIView
    var collectionView: UICollectionView

    let durationFormatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.hour, .minute, .second]
        f.zeroFormattingBehavior = .pad
        return f
    }()
    let priceFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        return f
    }()

    var projects: [Project] { return dataStore.data }

    let dataStore: DataStore<Project>

    var trackingProject: Project?

    init(dataStore: DataStore<Project> = DataStore()) {
        self.dataStore = dataStore
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.statusBarBackground = UIView(frame: .zero)

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.darkness
        statusBarBackground.backgroundColor = Colors.primary
        view.addSubview(statusBarBackground)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: UIApplication.shared.statusBarFrame.height + 8, left: 0, bottom: 0, right: 0)
        collectionView.contentOffset = CGPoint(x: 0, y: -collectionView.contentInset.top)
        collectionView.backgroundColor = .clear
        collectionView.register(ProjectCell.self, forCellWithReuseIdentifier: ProjectCell.reuseIdentifier)
        view.addSubview(collectionView)

        constrain(view, statusBarBackground, collectionView) { container, bar, table in
            bar.top == container.top
            bar.height == UIApplication.shared.statusBarFrame.height
            bar.left == container.left
            bar.right == container.right

            table.top == container.topMargin
            table.leading == container.leading
            table.trailing == container.trailing
            table.bottom == container.bottom
        }

        view.bringSubview(toFront: statusBarBackground)

        dataStore.load()

        if let tracking = projects.index(where: { $0.isTracking }) {
            let project = projects[tracking]
            trackingProject = project
        }
    }
}

extension ProjectsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projects.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectCell.reuseIdentifier, for: indexPath) as! ProjectCell

        let project = projects[indexPath.item]

        cell.configure(with: project, at: indexPath, delegate: self)
        return cell
    }
}

extension ProjectsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right - 16, height: 128)
    }
}

extension ProjectsViewController: ProjectCellDelegate {
    func buttonTapped(at indexPath: IndexPath) {
        let project = projects[indexPath.item]
        var indexPaths = [indexPath]
        defer {
            collectionView.reloadItems(at: indexPaths)
            dataStore.save()
        }

        if project.isTracking { // Stop tracking
            trackingProject = nil
            project.stop()
        } else { // Start tracking (stop previous first)
            if let prev = self.trackingProject, let prevIndex = self.projects.index(of: prev) {
                prev.stop()
                indexPaths.append(IndexPath(item: prevIndex, section: 0))
            }

            project.start()
            trackingProject = project
        }
    }
}
