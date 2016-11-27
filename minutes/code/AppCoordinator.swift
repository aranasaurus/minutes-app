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

    let projectsFlowController: ProjectsFlowController
    init() {
        window = UIWindow(frame: UIScreen.main.bounds)
        projectsFlowController = ProjectsFlowController(dataStore: DataStore())
    }

    func startUp() {
        window.rootViewController = projectsFlowController.root
        window.makeKeyAndVisible()
    }
}
