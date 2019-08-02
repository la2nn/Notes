//
//  ColorPickerViewController.swift
//  Notes
//
//  Created by Николай Спиридонов on 18/07/2019.
//  Copyright © 2019 nnick. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController {
    
    var mainView = PickerView()
    var delegate: ColorPickerViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

            self.mainView.delegate = self
            self.view.addSubview(self.mainView)
            
            self.mainView.translatesAutoresizingMaskIntoConstraints = false
            let leading = self.mainView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0)
            let trailing = self.mainView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
            let top = self.mainView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
            let bottom = self.mainView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
            
            NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
    
}

extension ColorPickerViewController: PickerViewDelegate {
    func doneTouched(sendColor color: UIColor) {
        delegate.getColor(pickedColor: color)
        dismiss(animated: true, completion: nil)
    }
}

protocol ColorPickerViewControllerDelegate {
    func getColor(pickedColor: UIColor)
}


