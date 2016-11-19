//
//  AppCoordinator.swift
//  Minutes
//
//  Created by Ryan Arana on 11/19/16.
//  Copyright © 2016 Aranasaurus. All rights reserved.
//

import UIKit

class AppCoordinator {
    let window: UIWindow

    let projectsDataStore: DataStore<Project>
    init() {
        window = UIWindow(frame: UIScreen.main.bounds)
        projectsDataStore = DataStore()
    }

    func startUp() {
        window.rootViewController = ProjectsViewController(dataStore: projectsDataStore, eventHandler: self)
        window.makeKeyAndVisible()
    }
}

extension AppCoordinator: ProjectsEventHandler {
    func selectedProject(_ project: Project) {
        print("\(project.name) selected.")
        let popup = UIAlertController(title: project.name, message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Sessions", style: .default) { _ in
            print("Sessions selected for \(project.name)")
        }
        popup.addAction(action)
        
        window.rootViewController?.present(popup, animated: true, completion: nil)
    }
}
