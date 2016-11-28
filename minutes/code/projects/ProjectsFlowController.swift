//
//  ProjectsFlowController.swift
//  Minutes
//
//  Created by Ryan Arana on 11/27/16.
//  Copyright © 2016 Aranasaurus. All rights reserved.
//

import UIKit

class ProjectsFlowController: NSObject {
    let dataStore: DataStore<Project>
    var root: ProjectsViewController!
    var selectedProject: Project? = nil

    init(dataStore: DataStore<Project>) {
        self.dataStore = dataStore

        super.init()

        self.root = ProjectsViewController(dataStore: dataStore, onProjectSelected: onProjectSelected)
    }

    func onProjectSelected(project: Project) {
        selectedProject = project
        let popup = UIAlertController(title: project.name, message: nil, preferredStyle: .actionSheet)

        let rename = UIAlertAction(title: "Rename", style: .default) { _ in
            let alert = UIAlertController(title: "Rename \(project.name)", message: nil, preferredStyle: .alert)
            alert.addTextField { textField in
                textField.text = project.name
                textField.clearButtonMode = .whileEditing
                textField.spellCheckingType = .default
                textField.autocapitalizationType = .words
                textField.returnKeyType = .done
                textField.delegate = self
            }
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.root.present(alert, animated: true, completion: nil)
        }
        popup.addAction(rename)

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

extension ProjectsFlowController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let project = selectedProject else { return }
        project.name = textField.text ?? project.name
        dataStore.save()
        guard let index = dataStore.data.index(of: project) else { return }
        root.reload(at: index)
    }
}
