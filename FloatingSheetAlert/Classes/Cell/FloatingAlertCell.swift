//
//  FloatingAlertCell.swift
//  FlyAlert
//
//  Created by Alexandr Shevchenko on 14.10.2020.
//

import UIKit

class FloatingAlertCell: UITableViewCell {
    @IBOutlet private var iconImage: UIImageView!
    @IBOutlet private var arrowImage: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    
    @IBOutlet private var constraintArrow: NSLayoutConstraint!
    @IBOutlet private var arrowWidth: NSLayoutConstraint!
    
    func configure(with viewModel: ViewModelNormal, theme: FloatingSheetTheme){
        self.iconImage.image = viewModel.image
        titleLabel.text = viewModel.title
        titleLabel.font = theme.textFont
        titleLabel.textColor = theme.textColor
        
        let value: CGFloat = viewModel.hasArrow ? 16 : 0
        constraintArrow.constant = value
        arrowWidth.constant = value
    }
}

struct ViewModelNormal {
    let image: UIImage?
    let title: String
    let hasArrow: Bool
    let isDismiss: Bool
    let onTap: (() -> Void)?
}
