//
//  ProjectsFlowController.swift
//  Minutes
//
//  Created by Ryan Arana on 11/27/16.
//  Copyright © 2016 Aranasaurus. All rights reserved.
//

import UIKit

class ProjectsFlowController: NSObject {
    static let moneyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencyGroupingSeparator = ","
        return formatter
    }()

    fileprivate enum TextFields: Int {
        case rename
        case setRate
    }

    let dataStore: DataStore<Project>
    var root: ProjectsViewController!
    var selectedProject: Project? = nil

    init(dataStore: DataStore<Project>) {
        self.dataStore = dataStore

        super.init()

        self.root = ProjectsViewController(dataStore: dataStore, onProjectSelected: onProjectSelected)
    }

    func setupRootNav() {
        root.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addProjectTapped))
    }

    func addProjectTapped() {
        let alert = UIAlertController(title: "New Project", message: nil, preferredStyle: .alert)
        alert.addTextField() { textField in
            textField.placeholder = "Name"
            textField.autocapitalizationType = .words
            textField.keyboardType = .alphabet
        }
        alert.addTextField() { textField in
            textField.placeholder = "Default Rate"
            textField.keyboardType = .decimalPad
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default) { action in
            guard action.title == "Add" else { return }

            // TODO: Error handling
            let name = alert.textFields!.first!.text!
            let rate = Double(alert.textFields![1].text!)!

            // TODO: Yikes this dataStore needs some work, this stuff shouldn't be being done here (the identifier generation and appending to the data array).
            self.dataStore.data.append(Project(identifier: name.hash, name: name, defaultRate: rate))
            self.dataStore.save()
            self.root.reload()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        root.present(alert, animated: true, completion: nil)
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
                textField.tag = TextFields.rename.rawValue
            }
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.root.present(alert, animated: true, completion: nil)
        }
        popup.addAction(rename)

        let setRate = UIAlertAction(title: "Set Rate", style: .default) { _ in
            let alert = UIAlertController(title: "Set Rate", message: nil, preferredStyle: .alert)
            alert.addTextField { textField in
                textField.text = ProjectsFlowController.moneyFormatter.string(from: NSNumber(floatLiteral: project.defaultRate))
                textField.clearButtonMode = .never
                textField.keyboardType = .numbersAndPunctuation
                textField.returnKeyType = .done
                textField.delegate = self
                textField.tag = TextFields.setRate.rawValue
            }
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.root.present(alert, animated: true, completion: nil)
        }
        popup.addAction(setRate)

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
        guard
            let project = selectedProject,
            let field = TextFields.init(rawValue: textField.tag)
            else { return }

        switch field {
        case .rename:
            project.name = textField.text ?? project.name
            dataStore.save()
        case .setRate:
            guard
                let text = textField.text,
                let rate = ProjectsFlowController.moneyFormatter.number(from: text)?.doubleValue
                else { return }
            project.defaultRate = rate
            dataStore.save()
        }

        guard let index = dataStore.data.index(of: project) else { return }
        root.reload(at: index)
    }
}
