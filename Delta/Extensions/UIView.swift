//
//  UIView.swift
//  Delta
//
//  Created by Dino Constantinou on 11/01/2018.
//  Copyright © 2018 Dino Constantinou. All rights reserved.
//

import UIKit

extension UIView {

    func pinToSuperviewEdges() {
        guard let superview = superview else {
            return
        }
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leftAnchor.constraint(equalTo: superview.leftAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            rightAnchor.constraint(equalTo: superview.rightAnchor)
        ])
    }
    
    func pinToSuperviewSafeAreaLayoutGuide() {
        let margins = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: margins.topAnchor),
            leftAnchor.constraint(equalTo: margins.leftAnchor),
            bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            rightAnchor.constraint(equalTo: margins.rightAnchor)
        ])
    }
    
}
