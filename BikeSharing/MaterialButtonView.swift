//
//  ButtonView.swift
//  BikeSharing
//
//  Created by Vishal Bharam on 9/30/17.
//  Copyright © 2016 codecoop. All rights reserved.
//

import UIKit

class MaterialButtonView: UIButton {
    
    override func awakeFromNib() {
        layer.cornerRadius = 4.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
    }
}
