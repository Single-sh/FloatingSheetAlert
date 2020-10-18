//
//  FloatingSwitchCell.swift
//  FlyAlert
//
//  Created by Alexandr Shevchenko on 15.10.2020.
//

import UIKit

class FloatingSwitchCell: UITableViewCell {
    @IBOutlet private var iconImage: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var switchControl: UISwitch!
    
    var onToggle: ((Bool) -> Void)?
    
    @IBAction func switchTap(_ sender: UISwitch) {
        onToggle?(sender.isOn)
    }
    
    func configure(with viewModel: ViewModelToggle, theme: FloatingSheetTheme){
        iconImage.image = viewModel.image
        titleLabel.text = viewModel.title
        switchControl.isOn = viewModel.isOn
        switchControl.isEnabled = !viewModel.isDisabled
        self.onToggle = viewModel.onToggle
        
        titleLabel.font = theme.textFont
        titleLabel.textColor = theme.textColor
    }
}

struct ViewModelToggle {
    let image: UIImage?
    let title: String
    let isOn: Bool
    let isDisabled: Bool
    let onToggle: ((Bool) -> Void)
}
