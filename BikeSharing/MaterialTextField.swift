//
//  MaterialTextField.swift
//  Ouath Login
//
//  Created by Vishal Bharam on 2/3/16.
//  Copyright © 2016 codecoop. All rights reserved.
//

import UIKit

class MaterialTextField: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    } 
    */
    
    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.1).cgColor
        layer.borderWidth = 1.0
    }
    
    // For PlaceHolder
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    // For Editable Text
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }

}
