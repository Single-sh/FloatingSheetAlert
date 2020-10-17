//
//  FloatingAlertCell.swift
//  FlyAlert
//
//  Created by Alexandr Shevchenko on 14.10.2020.
//

import UIKit

class FloatingAlertCell: UITableViewCell, FloatingCellDelegate {
    var action: (() -> Void)?
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    func hideArrow() {
        arrowImage.isHidden = true
    }
    
    func didSelect() {
        action?()
    }
    
    func setTitle(icon: UIImage?, title: String) {
        self.iconImage.image = icon
        titleLabel.text = title
    }
    
    func setFontTitle(font: UIFont) {
        titleLabel.font = font
    }
    
    func setAction(action: Any) {
        self.action = action as? (() -> Void)
    }
}
