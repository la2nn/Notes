//
//  PickerView.swift
//  Notes
//
//  Created by Николай Спиридонов on 18/07/2019.
//  Copyright © 2019 nnick. All rights reserved.
//

import UIKit

class PickerView: UIView {

    @IBOutlet weak var chosenColor: UIView!
    @IBOutlet weak var palette: HSBColorPicker!
    @IBOutlet weak var chosenColorLabel: UILabel!
    @IBOutlet weak var brightnessSlider: UISlider!
    
    var delegate: PickerViewDelegate!
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        delegate.doneTouched(sendColor: chosenColor.backgroundColor ?? .white)
    }
    
    @IBAction func changeBrightnessValue(_ sender: UISlider) {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        chosenColor.backgroundColor?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        let newColor = UIColor(hue: hue, saturation: saturation, brightness: CGFloat(sender.value), alpha: alpha)
        
        UIView.animate(withDuration: 0.17) {
            sender.setValue(Float(brightness), animated: true)
        }
        
        chosenColorLabel.text = "\(newColor.hexString ?? "NaN")"
        chosenColor.backgroundColor = newColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let xibView = loadViewFromXib()
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(xibView)
        
        // Set delegate
        palette.delegate = self
        
        // Make borders for palette and View that represents picked color
        palette.layer.borderWidth = 2
        palette.layer.borderColor = UIColor.black.cgColor
        
        chosenColor.layer.borderWidth = 2
        chosenColor.layer.cornerRadius = chosenColor.frame.width / 10
        chosenColor.layer.borderColor = UIColor.black.cgColor
        chosenColor.backgroundColor = .white
        chosenColorLabel.text = chosenColor.backgroundColor?.hexString
    }
    
    private func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PickerView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
    
}

extension PickerView: HSBColorPickerDelegate {
    func HSBColorColorPickerTouched(sender: HSBColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizer.State) {
        chosenColor.backgroundColor = color
        changeBrightnessValue(brightnessSlider)
    }
}

protocol PickerViewDelegate {
    func doneTouched(sendColor color: UIColor)
}
