//
//  UIImageView+animations.swift
//  WeatherBrick
//
//  Created by Beavean on 26.12.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

extension UIImageView {
    func resetStonePosition() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseIn, .allowUserInteraction], animations: {
            self.transform = .identity
        }, completion: nil)
    }
    
    func swingStoneWithWindEffect() {
        let options: UIView.AnimationOptions = [.autoreverse, .repeat, .curveEaseInOut, .allowUserInteraction]
        UIView.animate(withDuration: 3, delay: 0.0, options: options, animations: {
            let translationX: CGFloat = self.frame.width / 10
            let translationAngle: CGFloat = -0.1
            let horizontalTranslation = CGAffineTransformMakeTranslation(translationX, 0)
            let rotationTranslation = CGAffineTransformRotate(horizontalTranslation, translationAngle)
            self.transform = CGAffineTransformTranslate(rotationTranslation, 0, 0)
        }, completion: nil)
    }
}
