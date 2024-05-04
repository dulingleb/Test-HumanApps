//
//  SettingViewModel.swift
//  Test HumanApps
//
//  Created by Dulin Gleb on 4.5.24..
//

import Foundation

protocol SettingViewModelProtocol: AnyObject {
    func setupDataSource()
}

class SettingViewModel {
    weak var view: SettingViewControllerProtocol?
}

extension SettingViewModel: SettingViewModelProtocol {
    func setupDataSource() {
        let dataSourceItems: [SettingTableModel] = [
            .init(title: NSLocalizedString("About", comment: ""), icon: .book, handler: {
                guard let navigation = self.view?.getNavController() else { return }
                let alert = Alert.set(message: "Dulin Gleb", title: NSLocalizedString("About", comment: ""))
                navigation.present(alert, animated: true)
            })
        ]
        
        view?.setupDataSource(items: dataSourceItems)
    }
}
