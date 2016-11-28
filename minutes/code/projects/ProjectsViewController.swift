//
//  ProjectsViewController.swift
//  Minutes
//
//  Created by Ryan Arana on 10/29/16.
//  Copyright © 2016 Aranasaurus. All rights reserved.
//

import UIKit
import Cartography

typealias ProjectSelectedBlock = (_ project: Project) -> Void

final class ProjectsViewController: UIViewController {
    fileprivate var collectionView: UICollectionView

    // TODO: There's a better way to do these, ViewModel, maybe?
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

    fileprivate var projectSelected: ProjectSelectedBlock?
    fileprivate var projects: [Project] { return dataStore.data }
    fileprivate let dataStore: DataStore<Project>
    fileprivate var trackingProject: Project?

    init(dataStore: DataStore<Project>, onProjectSelected: ProjectSelectedBlock?) {
        self.dataStore = dataStore
        self.projectSelected = onProjectSelected
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

        super.init(nibName: nil, bundle: nil)

        self.title = "Projects"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.darkness

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        collectionView.contentOffset = CGPoint(x: 0, y: -collectionView.contentInset.top)
        collectionView.backgroundColor = .clear
        collectionView.register(ProjectCell.self, forCellWithReuseIdentifier: ProjectCell.reuseIdentifier)
        view.addSubview(collectionView)

        constrain(view, collectionView) { container, table in
            table.top == container.topMargin
            table.leading == container.leading
            table.trailing == container.trailing
            table.bottom == container.bottom
        }

        dataStore.load()

        if let tracking = projects.index(where: { $0.isTracking }) {
            let project = projects[tracking]
            trackingProject = project
        }
    }

    func clearSelection(animated: Bool = true) {
        guard let selected = collectionView.indexPathsForSelectedItems?.first else { return }
        collectionView.deselectItem(at: selected, animated: animated)
    }

    func remove(at index: Int) {
        collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
    }

    func reload(at index: Int) {
        collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
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
        let insets = collectionView.contentInset
        let width = collectionView.bounds.width - insets.left - insets.right - 16
        let maxHeight = CGFloat(145)
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize(width: width, height: maxHeight) }
        let visibleItems: CGFloat = collectionView.traitCollection.verticalSizeClass == .compact ? 2 : 4
        let height = min(maxHeight, (collectionView.bounds.height - insets.top - insets.bottom - (layout.minimumLineSpacing * visibleItems + 1)) / visibleItems)
        return CGSize(width: width, height: height)
    }
}

extension ProjectsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard !(collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return false
        }

        return true
    }

    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        projectSelected?(projects[indexPath.item])
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
