//
//  UIView+FadeAnimation.swift
//  WeatherBrick
//
//  Created by Beavean on 30.12.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

extension UIView {
    func fadeOut() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0
        }
    }
    
    func fadeIn() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
        }
    }
}
