//
//  SettingTableDataSource.swift
//  Test HumanApps
//
//  Created by Dulin Gleb on 4.5.24..
//

import Foundation
import UIKit

final class SettingTableDataSource: NSObject {
    weak var tableView: UITableView?
    
    private var items: [SettingTableModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    public func setItems(items: [SettingTableModel]) {
        self.items = items
    }
}

extension SettingTableDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.reuseIdentifier, for: indexPath) as? SettingTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(item: items[indexPath.row])
        
        return cell
    }
}

extension SettingTableDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = items[indexPath.row]
        item.handler()
    }
}
