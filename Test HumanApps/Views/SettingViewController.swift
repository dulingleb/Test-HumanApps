//
//  SettingViewController.swift
//  Test HumanApps
//
//  Created by Dulin Gleb on 4.5.24..
//

import UIKit

protocol SettingViewControllerProtocol: AnyObject {
    func setupDataSource(items: [SettingTableModel])
    func getNavController() -> UINavigationController?
}

class SettingViewController: UIViewController {
    var viewModel: SettingViewModelProtocol?
    let dataSource = SettingTableDataSource()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.setupDataSource()
        setupViews()
        setupConstraints()
        setupTableView()
    }

}

private extension SettingViewController {
    func setupViews() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: SettingTableViewCell.reuseIdentifier)
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        dataSource.tableView = tableView
    }
}

extension SettingViewController: SettingViewControllerProtocol {
    func setupDataSource(items: [SettingTableModel]) {
        self.dataSource.setItems(items: items)
    }
    
    func getNavController() -> UINavigationController? {
        return self.navigationController ?? nil
    }
}
