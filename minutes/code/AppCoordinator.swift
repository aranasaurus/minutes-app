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
    init() {
        window = UIWindow(frame: UIScreen.main.bounds)
    }

    func startUp() {
        window.rootViewController = ProjectsViewController( eventHandler: self)
        window.makeKeyAndVisible()
    }
}

extension AppCoordinator: ProjectsEventHandler {
    func selectedSessions(for project: Project) {
        print("Sessions selected for \(project.name)")
    }
}
