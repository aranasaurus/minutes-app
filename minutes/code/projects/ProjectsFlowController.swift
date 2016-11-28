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
        let delete = UIAlertAction(title: "Delete", style: .destructive) { _ in
            guard let index = self.dataStore.data.index(of: project) else { return }
            self.dataStore.data.remove(at: index)
            self.root.remove(at: index)
            self.dataStore.save()
        }
        popup.addAction(delete)

        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.root.clearSelection()
        }
        popup.addAction(cancel)

        root.present(popup, animated: true, completion: nil)
    }
}
