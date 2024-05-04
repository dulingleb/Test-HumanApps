//
//  TapBar.swift
//  Test HumanApps
//
//  Created by Dulin Gleb on 2.5.24..
//

import UIKit

class TapBar: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupVCs()
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                         icon: Icon,
                                         title: String? = nil) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = icon.uiImage
        navController.navigationBar.prefersLargeTitles = false
        rootViewController.navigationItem.title = title
        return navController
    }
    
    func setupVCs() {
        viewControllers = [
            createNavController(for: MainScreenConfigurator.instantiateModule(), icon: .main, title: NSLocalizedString("Main", comment: "")),
            createNavController(for: SettingScreenConfiguarator.instatiateModule(), icon: .setting, title: NSLocalizedString("Setting", comment: ""))
        ]
    }
}

