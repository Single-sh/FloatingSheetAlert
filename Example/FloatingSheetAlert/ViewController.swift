//
//  ViewController.swift
//  FloatingSheetAlert
//
//  Created by shevchenko.a.i14@gmail.com on 10/17/2020.
//  Copyright (c) 2020 shevchenko.a.i14@gmail.com. All rights reserved.
//

import UIKit
import FloatingSheetAlert

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onTap(_ sender: UIButton) {
        let yes = FloatingAlertAction.normal( title: "Yes") {
            print("yes")
        }
        let no = FloatingAlertAction.normalArrow(title: "no", isDismiss: false) {
            print("no")
        }

        let toggle = FloatingAlertAction.toggle(title: "Овер дохрена длинный текст, что бы на 2ю строку вылез прям", isOn: false) { (isOn) in
            print(isOn)
        }

        let alert = FloatingAlertController(icon: nil, title: "Текст", action: [yes,no, toggle])
        self.present(alert, animated: false, completion: nil)
    }
}

extension FloatingAlertController {
    convenience init(icon: UIImage?, title: String, action: [FloatingAlertAction]) {
        self.init()
        var array = action
        array.insert(.separator, at: 0)
        array.insert(.title(icon: icon, title: title), at: 0)
        self.setActions(array)
    }
}

