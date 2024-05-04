//
//  SettingScreenConfiguarator.swift
//  Test HumanApps
//
//  Created by Dulin Gleb on 4.5.24..
//

import Foundation

final class SettingScreenConfiguarator {
    static func instatiateModule() -> SettingViewController {
        let controller = SettingViewController()
        let viewModel = SettingViewModel()
        
        viewModel.view = controller
        controller.viewModel = viewModel
        
        return controller
    }
}
