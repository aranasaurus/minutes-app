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

    let formatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.hour, .minute, .second]
        f.zeroFormattingBehavior = .pad
        return f
    }()

    let data = stride(from: 0, to: 10, by: 1).map {
        return Project(id: "\($0)", name: "Project \($0)", tracker: Tracker(identifier: "\($0)", updateBlock: nil), price: 0)
    }

    init() {
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

        view.backgroundColor = Colors.darkBackground
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
    }

}

extension ProjectsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectCell.reuseIdentifier, for: indexPath) as! ProjectCell
        cell.configure(for: data[indexPath.item], formatter: formatter)
        return cell
    }
}

extension ProjectsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right - 16, height: 128)
    }
}
