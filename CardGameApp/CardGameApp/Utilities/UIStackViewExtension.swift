//
//  UIStackViewExtension.swift
//  CardGameApp
//
//  Created by 심 승민 on 2018. 2. 2..
//  Copyright © 2018년 심 승민. All rights reserved.
//

import UIKit

extension UIStackView {
    func configureStackSetting(axis: UILayoutConstraintAxis, distribution: UIStackViewDistribution, spacing: CGFloat) {
        self.axis = axis
        self.distribution = distribution
        self.spacing = spacing
    }
}