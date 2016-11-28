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
        let nav = UINavigationController(rootViewController: projectsFlow.root)
        nav.navigationBar.tintColor = Colors.tint
        nav.navigationBar.barTintColor = Colors.primary
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.barStyle = .black
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }
}
