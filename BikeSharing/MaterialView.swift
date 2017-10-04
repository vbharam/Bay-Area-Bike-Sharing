//
//  MaterialView.swift
//  BikeSharing
//
//  Created by Vishal Bharam on 9/30/17.
//  Copyright © 2016 codecoop. All rights reserved.
//

import UIKit

class MaterialView: UIView {

    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).cgColor
        layer.shadowOpacity = 0.9
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            // It's an iPhone
            layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            break
        case .pad:
            // It's an iPad
            layer.shadowOffset = CGSize(width: 0.0, height: 12.0)
            break
        case .unspecified:
            // Uh, oh! What could it be?
            break
        default:
            break
        }
        

    }
}
