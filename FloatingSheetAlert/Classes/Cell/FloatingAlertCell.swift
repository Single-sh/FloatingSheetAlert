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
    
    func configure(with viewModel: ViewModelNormal){
        self.iconImage.image = viewModel.image
        titleLabel.text = viewModel.title
        arrowImage.isHidden = !viewModel.hasArrow
    }
}

struct ViewModelNormal {
    let image: UIImage?
    let title: String
    let hasArrow: Bool
    let isDismiss: Bool
    let onTap: (() -> Void)?
}
