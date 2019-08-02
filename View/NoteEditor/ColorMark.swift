//
//  ColorMark.swift
//  Notes
//
//  Created by Николай Спиридонов on 09/07/2019.
//  Copyright © 2019 nnick. All rights reserved.
//

import UIKit

@IBDesignable
class ColorMark: UIView {
    
    @IBInspectable var shouldDrawMark: Bool = false
    
    override func draw(_ rect: CGRect) {
       
        super.draw(rect)
        if shouldDrawMark {
            let color = UIColor.black
            color.setStroke()
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: rect.width * 40 / 77, y: rect.height * 22 / 75))
            path.addLine(to: CGPoint(x: rect.width * 50 / 77, y: rect.height * 32 / 75))
            path.addLine(to: CGPoint(x: rect.width * 65 / 77, y: rect.height * 12 / 75))
            path.lineWidth = 3
            path.stroke()
            path.close()
            
            let oval = UIBezierPath(ovalIn: CGRect(x: rect.width * 36 / 77,
                                                   y: rect.height * 5 / 75,
                                                   width: rect.width * 35 / 75,
                                                   height: rect.height * 35 / 75))
            oval.lineWidth = 2
            oval.stroke()
        }
        
        self.setNeedsDisplay()
    }
    
}
