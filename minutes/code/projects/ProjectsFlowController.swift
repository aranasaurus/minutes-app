//
//  ProjectsFlowController.swift
//  Minutes
//
//  Created by Ryan Arana on 11/27/16.
//  Copyright © 2016 Aranasaurus. All rights reserved.
//

import UIKit

class ProjectsFlowController {
    let dataStore: DataStore<Project>
    var root: ProjectsViewController!

    init(dataStore: DataStore<Project>) {
        self.dataStore = dataStore
        self.root = ProjectsViewController(dataStore: dataStore, onProjectSelected: onProjectSelected)
    }

    func onProjectSelected(project: Project) {
        print("\(project.name) selected.")
        let popup = UIAlertController(title: project.name, message: nil, preferredStyle: .actionSheet)
        let sessionsAction = UIAlertAction(title: "Sessions", style: .default) { _ in
            print("Sessions selected for \(project.name)")
        }
        popup.addAction(sessionsAction)

        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.root.clearSelection()
        }
        popup.addAction(cancel)

        root.present(popup, animated: true) {
            print("here")
        }
    }
}
