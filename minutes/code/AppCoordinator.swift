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

    let projectsFlow: ProjectsFlowController
    init() {
        window = UIWindow(frame: UIScreen.main.bounds)
        projectsFlow = ProjectsFlowController(dataStore: DataStore())
    }

    func startUp() {
        window.rootViewController = projectsFlow.root
        window.makeKeyAndVisible()
    }
}
