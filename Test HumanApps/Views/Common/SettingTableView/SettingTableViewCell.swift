//
//  SettingTableViewCell.swift
//  Test HumanApps
//
//  Created by Dulin Gleb on 4.5.24..
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.iconImageView.isHidden = true
    }
    
    public func configure(item: SettingTableModel) {
        self.titleLabel.text = item.title
        if let icon = item.icon {
            self.iconImageView.image = icon.uiImage
            self.iconImageView.isHidden = false
        }
    }
    
}
