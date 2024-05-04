//
//  MainScreenConfigurator.swift
//  Test HumanApps
//
//  Created by Dulin Gleb on 2.5.24..
//

import Foundation

final class MainScreenConfigurator {
    static func instantiateModule() -> MainViewController {
        let controller: MainViewController = MainViewController()
        let viewModel = MainViewModel()

        viewModel.view = controller
        controller.viewModel = viewModel

        return controller
    }
}
