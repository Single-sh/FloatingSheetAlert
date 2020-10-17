//
//  FloatingSwitchCell.swift
//  FlyAlert
//
//  Created by Alexandr Shevchenko on 15.10.2020.
//

import UIKit

class FloatingSwitchCell: UITableViewCell, FloatingCellDateSource {
    func hideArrow() {
        
    }
    
    var action: ((UISwitch) -> Void)?
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchControl: UISwitch!

    @IBAction func switchTap(_ sender: UISwitch) {
        action?(sender)
    }
    
    func setTitle(icon: UIImage?, title: String) {
        self.iconImage.image = icon
        titleLabel.text = title
    }
    
    func setFontTitle(font: UIFont) {
        titleLabel.font = font
    }
    
    func setAction(action: Any) {
        self.action = action as? ((UISwitch) -> Void)
    }
    
    public func switchState(state: Bool) {
        switchControl.isOn = state
    }
}
